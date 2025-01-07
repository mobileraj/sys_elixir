This lesson will span 2-3 weeks as its an overall exploration of Elixir programming language

- Install Elixir on your windows https://elixir-lang.org/install.html
    - Document if the install instructions worked or if you needed to change anything to get it to work
    - In addition to your VS Code as IDE, explore Neovim support for Elixir. This is just for an assignment and you dont need to use NV for development. Document the setup with some screenshots.
- Start with the [koans](https://github.com/elixirkoans/elixir-koans)

**Assignments**

- Documentation of NV setup to write helloworld programs with screenshot. Any specific configuration or setup can also be checked in to a folder under les3
- Write a simple program that does the following:
    - 1) Takes in a json file of name, address, email and stores it into a local store. Supports query of the data stored using email or name lookup
    - 2) Takes in a json file of name, US address (with state, zip) and email, stores it, with support for listing all address by state
    - 3) write service1 that supports webhook call back that provides 1/2 above via an API. Then write a webhook service2 to receive messages from the service1, when there is a call for search to specific addresses to service1
    - 4) Explore building a web UI to 1/2 using Phoenix Liveview
    - 5) Write a service that uses Google Firebase to store 1/2
    
