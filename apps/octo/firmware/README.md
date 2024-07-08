# firmware

Using https://github.com/axelson/inky_tester as a reference.

## Notes

- Try the main branch of scenic_driver_local on the rpi4. There is support for rpi4 that works well with the new cairo driver on main
- Add BR2_PACKAGE_CAIRO=y to nerves_defconfig in nerves_system_rpi4 for it to build
