import os
import argparse
import yaml

import numpy as np
import torch

torch.set_num_threads(1)

from src import config
from src.loop import loop
from src.custom_functions import (
    # generate_objective_from_gp_post,
    compute_rewards,
    # get_lengthscale_hyperprior,
)
from src.custom_functions import rover
from botorch.test_functions import Ackley


LOG_WANDB = False

if LOG_WANDB:
    import wandb

DIM = 200

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description="Run optimization of synthetic functions."
    )
    parser.add_argument("-c", "--config", type=str, help="Path to config file.")
    parser.add_argument("-o", "--objective", type=str, help="Objective function. Options: 'ackley', 'rover'.")

    args = parser.parse_args()
    with open(args.config, "r") as f:
        cfg = yaml.load(f, Loader=yaml.Loader)

    if args.objective is not None:
        if args.objective == "ackley":
            OBJECTIVE = Ackley(dim=DIM, negate=True)
        elif args.objective == "rover":
            OBJECTIVE = rover
        else:
            raise ValueError("Objective function not recognized. Please choose from 'ackley' or 'rover'.")

    # Translate config dictionary.
    cfg = config.insert(cfg, config.insertion_config)
    cfg = config.evaluate(cfg, DIM)
    if "seed" not in cfg:
        cfg["seed"] = 0

    parameters = {}
    calls = {}
    rewards = {}

    for trial in range(cfg["trials"]):
        current_seed = cfg["seed"] + trial
        np.random.seed(current_seed)
        torch.manual_seed(current_seed)

        if LOG_WANDB:
            wandb_run = wandb.init(
                project=f'{cfg["wandb_config"]["project_name"]}',
                entity=cfg["wandb_config"]["entity"],
            )

            wandb_run.name = cfg["wandb_config"]["name"]
        else:
            wandb_run = None

        sobol_eng = torch.quasirandom.SobolEngine(dimension=DIM)
        samples = sobol_eng.draw(cfg["seed"] + 1) * 6 - 3

        params, calls_in_iteration = loop(
            params_init=samples[-1, :],
            max_iterations=cfg["max_iterations"],
            max_objective_calls=cfg["max_objective_calls"],
            objective=OBJECTIVE,
            Optimizer=cfg["method"],
            optimizer_config=cfg["optimizer_config"],
            verbose=False,
            wandb_run=wandb_run,
        )

        parameters[trial] = torch.cat(params).numpy()
        calls[trial] = calls_in_iteration
        rewards[trial] = compute_rewards(torch.cat(params))

        if LOG_WANDB:
            wandb_run.finish()
    
    directory = cfg["out_dir"]
    if not os.path.exists(directory):
        os.makedirs(directory)
    np.save(os.path.join(directory, "parameters"), parameters)
    np.save(os.path.join(directory, "calls"), calls)
    np.save(os.path.join(directory, "rewards"), rewards)
