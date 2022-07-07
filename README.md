# [learning] Beetroot Paul's take on Dylan Bennett's PICO-8 Top-Down Adventure Game Tutorial

Tutorial YouTube playlist: https://www.youtube.com/watch?v=J1wvvbVQ5zo&list=PLdLmU93eWisKpyk1WZywUSYAq5dkCPFIv

I took 2 approaches on the tutorial.

First one is a regular, first-time approach. I wrote code in my way, but kinda similar to what Dylan has shown on their videos.

Second one is a rewrite of the first one to incorporate [Entity Component System (ECS)](https://en.wikipedia.org/wiki/Entity_component_system) with use of [Jess Telford's](https://github.com/jesstelford) [PECS library](https://github.com/jesstelford/pecs).

## Comparison of `INFO()` for both versions

`my_version_regular/`:

- tokens: 1203
- chars: 9843
- compressed: 2555

`my_version_with_pecs/`:

- tokens: 2315
- chars: 21650
- compressed: 5159
