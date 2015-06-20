#!/bin/bash

## @fn earlyboot_firstboot_start()
## Execute custom commands upon entering firstboot
custom_firstboot_begin()
{
	write_uart "M701 S255\r\n"
	write_uart "M702 S0\r\n"
	write_uart "M703 S0\r\n"
}

## @fn custom_firstboot_end()
## Execute custom commands upon leaving firstboot
custom_firstboot_end()
{
	true
}

## @fn custom_emergency_begin()
## Execute custom commands upon entering emergency procedure
custom_emergency_begin()
{
	true
}

## @fn custom_emergency_end()
## Execute custom commands upon leaving emergency procedure
custom_emergency_end()
{
	true
}
