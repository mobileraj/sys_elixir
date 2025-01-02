The state machine I simulate is that of a single lifeguard in a two-lifeguard pool (vastly simplified, although it covers most of the basics). A lifeguard can have the following states:
- ON_BREAK
- ON_DUTY
- SECONDARY_RESCUER
- PRIMARY_RESCUER
- REPORTER

Here are the events/transitions:
rotate:
- ON_BREAK --> ON_DUTY
- ON_DUTY --> ON_BREAK

clean:
- ON_BREAK --> ON_BREAK

yell_at_kids:
- ON_DUTY --> ON_DUTY

emergency:
- ON_DUTY --> PRIMARY_RESCUER
- ON_BREAK --> SECONDARY_RESCUER

rescue:
- PRIMARY_RESCUER --> REPORTER
- SECONDARY_RESCUER --> ON_DUTY

submit_report:
- ON_DUTY --> ON_DUTY
- REPORTER --> ON_BREAK



Each implementation contains a small demo program (only testing the positive cases, although a real application would need to test invalid states as well), starting with one guard in ON_BREAK. He does some cleaning. He rotates with his fellow guard, becoming on duty. He yells at some kids. Typical day. Then, an emergency occurs. He becomes the primary rescuer for the victims, and then the incident is documented.

**Note:** The state machine only can safely simulate one lifeguard in a pool with multiple other lifeguard. If we were to simulate these other lifeguards in a real application, the model would need to be adjusted because a lifeguard's ability to transition into a state depends on the state of the other lifeguards. For example, a lifeguard who is in the ON_DUTY state can only rotate into ON_BREAK if the other lifeguard is ON_BREAK and not a REPORTER. A few ways to implement this come to mind: by adding more granular states and transitions to lifeguards to restrict their ability to transitions; or by combining these states into one big state machine representing pool state (instead of individual lifeguards); or by representing states as a tuple, transitioning based on pattern matching; or by somehow communicating between state machines. In addition, there would need to be an assurance that each lifeguard received the events, as if one lifeguard receives the event but the other does not the pool could enter into an inconsistent, incoherent, or just bad-for-business state.

## My evaluation 
### Statemachine
- Very easy to get started, nice syntax. 
- Appears to be somewhat flexible. 
### Transitions