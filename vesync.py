#!/usr/bin/env python3
#
# Command line control of pyvesync, see https://pypi.org/project/pyvesync/
# feat. example options/values for the Levoit Core 200S air purifier
#
import sys, argparse
from pyvesync import VeSync

# Define command line arguments
parser = argparse.ArgumentParser(description="Sends commands to VeSync enabled air purifiers")
group = parser.add_mutually_exclusive_group(required=True)

# Available options are set for the Levoit Core 200S and will need modifying for other devices
group.add_argument("-i", "--info", action="store_true", help="display connected devices and status", required=False)
group.add_argument("-n", "--name", help="name of the purifier to set, use -i for a list", required=False)
parser.add_argument("-m", "--mode", help="set the mode: on, manual, sleep or off", choices=['on','manual','sleep','off'], required=False)
parser.add_argument("-l", "--light", help="set the night light: on, dim or off", choices=['on','dim','off'], required=False)
parser.add_argument("-s", "--speed", help="set the fan speed: 1, 2 or 3", type=int, choices=range(1, 4), required=False)
parser.add_argument("-c", "--clock", help="set the child lock: on or off", choices=['on','off'], required=False)
parser.add_argument("-d", "--displ", help="set the display: on or off", choices=['on','off'], required=False)

# Read command line arguments
args = parser.parse_args()

# Login to VeSync and get devices
manager = VeSync("your vesync login", "your vesync password", "your timezone, see https://en.wikipedia.org/wiki/List_of_tz_database_time_zones", debug=False)
manager.login()
manager.update()

if len(manager.fans) < 1:
  print("error: no VeSync purifier devices found on this account")
  sys.exit(1)

if args.info:
  print("\nVeSync device(s)")
  print("----------------\n")
  for device in manager.fans:
    # use device.modes to find all supported modes for your purifier if not a Core 200S
    # device.details["mode"] returns manual even in sleep, so this is using display() instead of the dictionary
    device.display()
    print()
  sys.exit(0)

if (args.mode == None and args.speed == None and args.light == None and args.clock == None and args.displ == None):
  print("error: you must specify your desired mode (-m), speed (-s), lighting (-l), child lock (-c) and/or display (-d)")
  sys.exit(2)
  
dev_found = False
for device in manager.fans:
  if device.device_name.lower() == args.name.lower():
    dev_found = True
    print("\nVeSync device: " + str(device.device_name))
    if args.clock != None:
      if args.clock.lower() == "on":
        device.child_lock_on()
        print("\u2022 Child lock: on") 
      else:
        device.child_lock_off()
        print("\u2022 Child lock: off") 
    if args.mode != None:
      if args.mode.lower() == "manual":
        # Setting device to manual sets fan speed to 1, so we need to set mode before fan
        device.manual_mode()
        print("\u2022 Device mode: manual") 
      elif args.mode.lower() == "sleep":
        device.sleep_mode()
        print("\u2022 Device mode: sleep") 
      elif args.mode.lower() == "on":
        device.turn_on()
        print("\u2022 Device mode: on") 
      else:
        device.turn_off()
        if args.light != None:
          # In case we want the device "off" but the light on.
          device.set_night_light(args.light.lower())
          print("\u2022 Night light: " + args.light.lower()) 
        # Need to exit here as setting fan speed will prevent turning off
        print("\u2022 Device mode: off") 
        sys.exit(0)
    if args.light != None:
      device.set_night_light(args.light.lower())
      print("\u2022 Night light: " + args.light.lower()) 
    if args.displ != None:
      if args.displ.lower() == "on":
        device.turn_on_display()
        print("\u2022 Display: on") 
      else:
        device.turn_off_display()
        print("\u2022 Display: off") 
    if args.speed != None:
      device.change_fan_speed(args.speed)
      print("\u2022 Fan speed: " + str(args.speed)) 

if not dev_found:
  print("error: no VeSync purifier device found with that name, use -i to see a list of devices")
  sys.exit(1)

sys.exit(0)