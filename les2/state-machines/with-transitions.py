from transitions import Machine, State;

class Lifeguard:
    states = [
        State('on break', on_enter=["on_enter_on_break"]),
        State('on duty', on_enter=["on_enter_on_duty"]),
        State('secondary rescuer', on_enter=["on_enter_secondary_rescuer"]),
        State('primary rescuer', on_enter=["on_enter_primary_rescuer"]),
        State('reporter', on_enter=["on_enter_reporter"])
    ];

    transitions = [
        {"trigger": 'rotate', "source": 'on break', "dest": 'on duty'},
        {"trigger": 'rotate', "source": 'on duty', "dest": 'on break'},
        {"trigger": 'clean', "source": 'on break', "dest": 'on break'},
        {"trigger": 'yell_at_kids', "source": 'on duty', "dest": 'on duty'},
        {"trigger": 'emergency', "source": 'on duty', "dest": 'primary rescuer'},
        {"trigger": 'emergency', "source": 'on break', "dest": 'secondary rescuer'},
        {"trigger": 'finish_rescue', "source": 'primary rescuer', "dest": 'reporter'},
        {"trigger": 'finish_rescue', "source": 'secondary rescuer', "dest": 'on duty'},
        {"trigger": 'submit_report', "source": 'reporter', "dest": 'on break'},
    ];

    def __init__(self, name):
        self.name = name;
        self.machine = Machine(model=self, states=Lifeguard.states, initial='on break', transitions=Lifeguard.transitions);

    
    def on_enter_on_break(self):
        print(f'{self.name}: chilling (and maybe cleaning) on break');

    def on_enter_on_duty(self):
        print(f'{self.name}: watching the pool. Don\'t run!');

    def on_enter_secondary_rescuer(self):
        print(f'{self.name}: oh no! My fellow guard is rescuing someone. I am going to provide backup');

    def on_enter_primary_rescuer(self):
        print(f'{self.name}: oh no! Someone\'s drowning. I am going to rescue them.');

    def on_enter_reporter(self):
        print(f'{self.name}: oh no! I have to do paperwork?? Ah well I\'m a lawyer');


lifeguard = Lifeguard('Rohan');

#Note: one difference is that on_enter is not called for the initial state in transitions but it is statemachine
lifeguard.clean();
lifeguard.rotate();
lifeguard.yell_at_kids();
lifeguard.emergency();
lifeguard.finish_rescue();
lifeguard.submit_report();
lifeguard.rotate();




