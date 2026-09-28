# SmoothMotionHost v0.1

A deliberately minimal Windows 11 D3D11 presentation host for testing NVIDIA Smooth Motion / SM86 with arbitrary game windows.

## Goal

Keep the path as small as possible:

`game window -> Windows Graphics Capture -> D3D11 texture -> flip-model Present -> Smooth Motion -> display`

There is no shader stack, GUI renderer, frame generation, sharpening, or temporal upscaler inside this program.

### Fast path

If the captured game size exactly matches the target monitor resolution and pixel format, each captured frame is copied directly into the swap-chain back buffer. No scaling pixel shader is executed.

### Scaling fallback

If the sizes differ, the program uses one point-sampled D3D11 pass with aspect-ratio preservation. This is intentionally basic; the purpose is to test Smooth Motion with minimal host overhead, not provide high-quality scaling.

## Requirements

- Windows 11 recommended
- DirectX 11 GPU
- Visual Studio 2022 with **Desktop development with C++**
- Windows 11 SDK (26100 recommended)
- CMake component installed with Visual Studio
- Your existing Smooth Motion SM86 installation if you want to inject Smooth Motion

## Build

Double-click:

`build_vs2022.cmd`

The executable should appear at:

`build\Release\SmoothMotionHost.exe`

If the build fails, copy the complete compiler error output back into ChatGPT.

## First test WITHOUT Smooth Motion

1. Start a game in **borderless/windowed** mode.
2. Run `run_without_sm86.cmd`.
3. The console lists visible windows.
4. Enter the number corresponding to the game.
5. The host creates a borderless output on the monitor containing that game.
6. Press **Ctrl+Shift+Q** to quit.

The console prints both captured FPS and presented FPS every two seconds.

Compare the game's FPS before and after enabling this host. This establishes the host's own overhead before SM86 is involved.

## Test WITH Smooth Motion SM86

After the non-SM86 test works, run:

`launch_with_sm86.cmd`

The command is already configured for:

`C:\Users\jack\AppData\Local\Programs\SmoothMotionSM86\sm86.exe`

SM86 launches `SmoothMotionHost.exe`; select the game window in the console. Smooth Motion should then target this process's D3D11 presentation path.

## Hotkeys

- **Ctrl+Shift+Q** — quit host
- **Ctrl+Shift+T** — toggle output always-on-top

## Optional arguments

You can launch directly with a title substring:

`SmoothMotionHost.exe --title "Sekiro"`

Enable normal Present VSync for comparison:

`SmoothMotionHost.exe --title "Sekiro" --vsync`

The default is Present VSync **off**, using tearing where supported, because the goal is to avoid inserting an additional presentation-rate limit before Smooth Motion. Test `--vsync` if the default path has obvious tearing or pacing instability.

## Recommended first performance test

For the lowest possible host overhead, temporarily run the game at the same resolution as the monitor. That activates the direct-copy fast path:

`capture texture -> CopyResource(backbuffer) -> Present`

Then test a lower game resolution separately. A lower-resolution source requires the one-pass scaling fallback and therefore adds another texture copy + draw.

## Current v0.1 limitations

- SDR BGRA8 path only; HDR handling is not implemented yet.
- Captures a specific window using Windows Graphics Capture.
- Borderless/windowed games are the intended source. Exclusive fullscreen may not capture correctly.
- Scaling is intentionally nearest-neighbour/point sampling.
- No explicit NVIDIA Reflex integration.
- No in-app window picker UI; selection is through the console.
- This is an experimental host. SM86 itself only validates selected presentation paths, so Smooth Motion compatibility is not guaranteed.

## What to report back

The most useful first numbers are:

1. Game alone FPS
2. Host FPS with `run_without_sm86.cmd`
3. `capture` and `present` FPS printed by the host
4. Game FPS with `launch_with_sm86.cmd`
5. Whether Smooth Motion doubles the displayed rate
6. GPU usage for tests 1, 2, and 4

If it crashes or freezes, include the console's last lines and any SM86 log generated for SmoothMotionHost.
