from statemachine import StateMachine, State;

class Lifeguard(StateMachine):
    on_break = State(initial=True); # when a lifeguard first comes in, they will be on break
    on_duty = State();
    secondary_rescuer = State();
    primary_rescuer = State();
    reporter = State();

    rotate = on_break.to(on_duty) | on_duty.to(on_break);
    clean = on_break.to.itself();
    yell_at_kids = on_duty.to.itself(); #frequent
    emergency = on_duty.to(primary_rescuer) | on_break.to(secondary_rescuer);
    finish_rescue = primary_rescuer.to(reporter) | secondary_rescuer.to(on_duty);
    submit_report = reporter.to(on_break) | on_duty.to(on_duty);

    def __init__(self, name):
        self.name = name;
        super().__init__();
    
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

lifeguard.activate_initial_state();
lifeguard.clean();
lifeguard.rotate();
lifeguard.yell_at_kids();
lifeguard.emergency();
lifeguard.finish_rescue();
lifeguard.submit_report();
lifeguard.rotate();


