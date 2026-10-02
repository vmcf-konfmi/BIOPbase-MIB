# BIOPbase-MIB

This repository packages the Microscopy Image Browser (MIB) into a container built on top of the BIOP desktop base image. It provides a desktop environment with VNC/noVNC access and includes the MIB standalone application.

## Requirements

- Docker
- Docker Compose

## Quick start

1. Clone this repository.
2. Start the container:

   ```bash
   docker compose up --build
   ```

3. Open the browser-based desktop client:

   - noVNC: http://localhost:6901
   - VNC directly: localhost:5901

4. Launch MIB from the desktop shortcut or from the installed standalone launcher in `/opt/mib`.

## Standalone MIB (Linux, x64)

If you have a MATLAB license, it is recommended to use the MIB for MATLAB environment distribution of MIB suitable for Windows, macOS and Linux. Otherwise use the standalone versions of MIB compiled for your operating system.

The Linux standalone installation flow follows the official MIB instructions:

- Requires 64-bit Linux
- Download the ZIP archive file with the recent release of MIB: `MIB2_Linux.zip`
- Extract the installer from the downloaded file
- Double-click on `MIB2_Linux.install` to start the installation process
- Choose the installation folder
- Choose the installation folder for the MATLAB runtime if prompted
- Accept the license agreement and complete the install
- Start MIB from a terminal using the generated launcher script and the MCR path, for example:

  ```bash
  /path/to/your/install/application/run_MIB.sh /path/to/your/MATLAB/Runtime/v97
  ```

- If the size of the MIB window is not optimal, adjust the GUI scaling
- Access help and tutorials from the MIB menu: `im_browser -> Menu -> Help -> Help`

This project intentionally follows the standalone Linux installation route rather than the MATLAB-based distribution.

## Files

- `Dockerfile` installs the required system libraries and the standalone MIB application.
- `docker-compose.yml` builds and runs the container with a shared data directory and VNC/noVNC ports.

## MIB installation notes

If you have a MATLAB license, it is recommended to use the MIB for MATLAB distribution of MIB suitable for Windows, macOS and Linux. Otherwise use the standalone versions of MIB compiled for your operating system.

### [VERSION 2] Run Microscopy Image Browser under MATLAB environment

- Requires MATLAB R2014b and newer
- Download the MATLAB distribution of the program: [MIB2_Matlab.zip](https://mib.helsinki.fi/web-update/MIB2_Matlab.zip)
- Unzip and copy the files to the `MIB` directory in your `Scripts` folder, for example `c:\MATLAB\Scripts\mib\`
- Start MATLAB
- Add the MIB starting directory (for example, `c:\MATLAB\Scripts\mib\`) to the MATLAB path via `MATLAB -> Home tab -> Set path... -> Add folder... -> Save`, or use the `pathtool` function from the MATLAB command window
- Type `mib` in the MATLAB command window and press Enter to start MIB
- Check the system requirements for optional steps such as Fiji or OMERO
- Access help and tutorials from the MIB menu: `MIB -> Menu -> Help -> Help`
- If the GUI widgets are too large or too small, adjust the GUI scaling

## Data persistence

The container mounts `./data` into the user's home directory at `/home/user/data` so files can be accessed from the host machine.

To use a different folder on the host, adjust the bind mount in `docker-compose.yml`:

```yaml
volumes:
  - /path/to/your/data:/home/user/data
```

## Useful commands

Build the image without starting it:

```bash
docker compose build
```

Stop and remove the container:

```bash
docker compose down
```

Recreate the container after changes:

```bash
docker compose up --build --force-recreate
```

## Notes

- The image is built as the `user` account for the desktop environment.
- The desktop shortcut is created under `/home/user/Desktop`.
- The tool is intended for local desktop access and interactive image browsing workflows.

