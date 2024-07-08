# AUTOGENERATED! DO NOT EDIT! File to edit: ../nbs/06_trainers.ipynb.

# %% auto 0
__all__ = ['BaseTrainer', 'SingleAgentTrainer']

# %% ../nbs/06_trainers.ipynb 4
from abc import ABC
from abc import abstractmethod
import os
from typing import *

from fastcore.basics import patch
import gymnasium as gym

from .agents import *
from .core import *
from .envs import *

# %% ../nbs/06_trainers.ipynb 6
class BaseTrainer(ABC):
    def __init__(
        self,
        agent: BaseAgent,
        env: gym.Env,
        rounds_train: int,
        rounds_eval: int,
        save_folder: Union[str, None] = None,
        save_interval: Union[int, None] = None,
        run_id: Union[str, None] = None,
        log_fn: Union[Callable, None] = None,
    ):
        self.agent = agent
        self.env = env
        self.rounds_train = rounds_train
        self.rounds_eval = rounds_eval
        self.save_folder = save_folder
        self.save_interval = save_interval
        self.run_id = run_id
        self.log_fn = log_fn

    def save(self, agent: BaseAgent, round: int) -> None:
        if run_id is None:
            run_id = "latest"

        save_path = f"{self.save_folder}/models/{self.run_id}/{round}"
        if os.path.exists(save_path):
            os.rmdir(save_path)

        os.makedirs(save_path)
        agent.save(save_path)

    def load(self, agent: BaseAgent, run_id: str, round: int) -> BaseAgent:
        if self.run_id is None:
            self.run_id = "latest"

        load_path = f"{self.save_folder}/models/{run_id}/{round}"
        if not os.path.exists(load_path):
            raise ValueError(f"Model path does not exist: {load_path}")

        agent.load(load_path)

        return agent

    @abstractmethod
    def train(self) -> None:
        ...

    @abstractmethod
    def evaluate(self) -> None:
        ...

# %% ../nbs/06_trainers.ipynb 8
class SingleAgentTrainer(BaseTrainer):
    def train(self, env: BaseEnv, agent: BaseAgent) -> None:
        for round in range(1, self.rounds_train + 1):
            state = env.reset()
            done = False
            loss = None
            while not done:
                action = agent.get_action(state)  # type: ignore
                done, state, next_state, reward, info = env.step(action)
                transition = (state, action, reward, next_state, done)
                loss = agent.step(transition)  # type: ignore
                state = next_state

            if self.log_fn is not None:
                log_dict = {
                    "loss": loss,
                }
                log_dict.update(info)
                self.log_fn(log_dict)

            if (
                self.save_folder is not None
                and self.save_interval is not None
                and round % self.save_interval == 0
            ):
                self.save(agent=agent, round=round)

    def evaluate(self, env: BaseEnv, agent: BaseAgent) -> None:
        total_reward = 0
        for _ in range(1, self.rounds_eval + 1):
            state = env.reset()
            done = False
            while not done:
                action = agent.get_action(state)  # type: ignore
                done, _, next_state, reward, _ = env.step(action)
                total_reward += reward
                state = next_state

        avg_total_reward = total_reward / self.rounds_eval
        print(f"Average total reward: {round(avg_total_reward, 2)}")
        if self.log_fn is not None:
            metrics = {"avg_total_reward": avg_total_reward}
            self.log_fn(metrics)
