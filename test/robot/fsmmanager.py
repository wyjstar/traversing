# -*- coding:utf-8 -*-

from fsm import FsmCommand


class FsmManager:
    def __init__(self):
        self._current_state = FsmCommand()
        self._current_state.enter_state()
        self._next_state = None

    def change_state(self, state):
        if self._current_state != state:
            self._next_state = state

    def frame(self):
        self._current_state.exec_state()

        if self._next_state is not None and \
                type(self._current_state) is not self._next_state:
            self._current_state.exit_state()
            self._current_state = self._next_state()
            self._current_state.enter_state()


fsm_manager = FsmManager()
