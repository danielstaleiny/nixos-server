# Server automation with NIX

## Initialize repozitory
- clone repo
- create Ubuntu 16. x64 LTS droplet
- add your keys you want to access with into `allowed_keys/`
- uncomment keys and import them in `nixos/configuration.nix`
- copy IPv4
- copy example.ip.nix and modify
   ```bash
   cp example.ip.nix ip.nix
   ```
- run init
   ```bash
   ./init
   ```
- You can now run deploy
   ```bash
   ./deploy
   ```


## to update channel
```bash
./channel-update
```

## to deploy
```bash
./deploy
```


## Your configuration should be under `nixos` folder



