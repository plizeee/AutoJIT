# AutoJIT

## What is AutoJIT?
- AutoJIT is an automation tool that enables MacOS users to wirelessly enable JIT over local network, without manually interacting with Xcode every single time.
## Why does AutoJIT exist?
- iOS 17 nerfed previous popular methods of enabling JIT in two crippling ways:
 1. No longer works on Windows
 2. No longer works over local network
- Xcode has a method of enabling JIT wirelessly; albeit still requiring manual interaction with the Mac on every activation
## What does AutoJIT do to solve these issues?
- AutoJIT only addresses problem #2
- It uses a UI automation tool (AppleScript) to manually interact with the UI
- It can trigger this script wirelessly from your iOS device by activating a shortcut that runs a command on the Mac using the SSH action
## Why AppleScript?
- Trust me, this wasn't my first choice
- Xcode has some CLI commands, but the only way to enable JIT wirelessly over CLI (from what I could find online at least) required terminal commands executed on the iOS device itself (not possible without a jailbroken device)
- I'm gonna ditch AppleScript as soon as I find a viable alternative
## What apps support AutoJIT?
- It looks like it works with pretty much all apps that use JIT
- I haven't tested all of them, but all the ones I've tested worked perfectly.
- Apps tested: Sudachi, Limon, DolphiniOS, PojavLauncher, Ignited
## How do I add more apps?
- Edit the shortcut
- Add new item to the menu (name this whatever you'd like)
- Add a `Text` action (within the new menu item) and enter the name of the app
- Add a `Set Variable` (within the new menu item) action, enter `App` as the variable name
- Select `Input`, then `Select Variable`, then select the text block you just added

# Setup

## On your iOS device:
1. Download `AutoJIT.shortcut` on your iOS device
2. Edit the shortcut
3. Add your Mac password in the password field for both SSH actions
4. Follow the Mac instructions for what to enter in the fields

## On your Mac:
1. Download `Placeholder.xcodeproj` and `AutoJIT.applescript` on your Mac.
2. Right-click `AutoJIT.applescript`, hold the option key and click **Copy "AutoJIT.applescript" as Pathname** and paste the text somewhere. Enter that text as the value for `path` in the shortcut.
3. Locate Hostname:
    - Open Terminal and use the command `hostname` and enter that as the value for `host` in the shortcut.
4. Locate user:
    - Open Terminal and use the command `whoami` and enter that as the value for `user` in the shortcut.
5. Enable SSH:
    - System Settings > General > Sharing > Turn on Remote Login


## Open `Placeholder.xcodeproj`
- If it prompts you to trust the project, click `Trust`
- This is just a placeholder project so that we can attach the debugger to the app.
- You could create your own empty project, but this might be easier.
## Download iOS SDK:
1. Xcode > Settings... > iOS 17.x (7.35gb)
    - Select whatever version your device is running.
    - When installing Xcode for the first time, you can specify to download the iOS SDK.

2. Plug in your device to your Mac, open Finder and select your device under Locations. Scroll down to Options and make sure to enable **Show this iPhone when on Wi-Fi**

3. Go to into Xcode > Window > Devices and Simulators, and make sure your device is paired. If you unplug your device, you should see an internet icon (looks kinda like this: :globe_with_meridians:)

Once your SDK is done downloading, test if local JIT works correctly.
1. Open Sudachi on your iOS device, then in Xcode, select Debug > Select Process by PID or Name, then enter `Sudachi`. Wait about 30 seconds for JIT to enable (the app should freeze for a few seconds once it's enabled). Test a game to make sure it's working properly. Close the app.

Test out the shortcut. You can add it to your Home Screen as an app with a custom icon, if you'd like.

# Troubleshooting

## JIT not enabled and Xcode displaying "Waiting to Attach...."
- This usually occurs when we try to open the app before it's ready.
- This should fix itself by running the shortcut again
- If this issue happens consistently for you, try increasing the delay in the first `wait` action in the shortcut by 1-5 seconds.

## Enabling JIT for Limon asks me to select an app
- This occurs because `Limón` got renamed to `Limon` for some reason recently.
- You can fix this by either updating to the latest stable version (1.0.8.4 as of writing this)
- Alternatively, you can edit the shortcut and rename the text block containing `Limon` to `Limón` (The text block is immediately above "Set Variable `App` to `Text`")

## The app is frozen forever
- This shouldn't be a frequent issue, just kill the app and run the shortcut again

## It says "JIT enabled" but it's not working
- This is a known issue, but just run the shortcut again and it should work

## AutoJIT.applescript execution error: System Events got an error: Can't get window 1 of process "Xcode". Invalid index
- This seems to happen when Xcode is not the active window.
- This can probably be fixed fairly easily soon, but for now, just make sure Xcode is the active window when you run, if you get this error.

## Phone cannot leave the app
- This can usually be fixed by manually detaching the debugger from the app (Xcode > Debug > Detach from [process name])
- In the extremely rare event that your device refuses to leave the app and Xcode is not reporting the app being attached, you can force restart your device (Quickly press and release Volume Up, then press and release Volume Down, then hold the power button until the Apple logo appears)
- I believe this issue is caused by the app being in a limbo state where it thinks the debugger is attached and paused, but the debugger is not actually attached.