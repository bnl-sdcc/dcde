#!/bin/env python3

import parsl
from parsl.config import Config
from parsl.executors.threads import ThreadPoolExecutor
from parsl.configs.local_threads import config
from parsl.app.app import python_app, bash_app

parsl.clear()
parsl.load(config)

@python_app()
def hello():
        return 'Hello World'

print(parsl.__version__)
print(hello().result())