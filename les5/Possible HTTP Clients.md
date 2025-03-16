Some possibilities: 
- [HTTPoison](https://github.com/edgurgel/httpoison)
- [Mint](https://github.com/elixir-mint/mint)
- [Finch](https://github.com/keathley/finch?tab=readme-ov-file)
- [Req](https://github.com/wojtekmach/req)


Here looks like a good break down: https://elixirforum.com/t/mint-vs-finch-vs-gun-vs-tesla-vs-httpoison-etc/38588/11

It seems for starters we could use req or maybe HTTPoison, as these would be the simplest, easiest out of the box to use. For high throughput we might want to use Finch. Mint is meant to be built on top of (very flexible, customizable) and may prove useful for a fine-tuned implementation.