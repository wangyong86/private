class Car:
    def __init__(self, speed, started=False):
        self.speed=speed
        self.started = started
        super().__init__()

    def Speed(self):
        if self.started:
            print(f"speed:{self.speed}")
