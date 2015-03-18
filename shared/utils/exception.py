class AuthError(Exception):
    """docstring for AuthError"""
    def __init__(self, val):
        super(AuthError, self).__init__()
        self.val = val
