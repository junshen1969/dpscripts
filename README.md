# README

Read this to know the list of scripts and what they do.



## List of scripts



| #    | Script                   | Description                                                  |
| ---- | ------------------------ | ------------------------------------------------------------ |
| 1    | check_opstate.sh         | List down all DataPower objects with its op-state of a particular domain. |
| 2    | disable_syslog_target.sh | Disable the syslog target if the local-address is 'management' of the physical appliance during cutover. |
| 3    | export.sh                | Export a domain.                                             |
| 4    | import.sh                | Import a domain with filtered deployment policies. Modify the scripts if you need to adjust the filters. |
| 5    | list_certs.sh            | List of the certificates of a domain.                        |
| 6    | list_down_certs.sh       | List objects that are enabled but down.                      |
| 7    | list_objects.sh          | List a particular DataPower object of a domain.              |
| 8    | reboot.sh                | Reboot the appliance.                                        |
| 9    | set_nic_state.sh         | Set the admin-state of a particular network interface.       |
| 10   | upgrade_firmware.sh      | Update firmware.                                             |



## Usage

To understand the parameters to pass in, just run the command and the required parameters will be displayed.

For example, set_nic_state.sh

```sh
$ ./set_nic_state.sh

Usage:
 ./set_nic_state.sh dp_host_or_ip dp_ssh_port dp_admin dp_pass eth<0|1|2|3> <enabled|disabled>
```

This means you need to pass in

- dp_host: The hostname or IP address of the DataPower
- dp_ssh_port: The SSH port
- dp_admin: The user with administrative rights
- dp_pass: The password of the user
- eth<0|1|2|3>: The name of the network interface
- <enabled|disabled>: The state to be set.



Therefore, you will need to execute the command this way

```sh
$ ./set_nic_state.sh 172.16.102.114 2022 admin Passw0rd! eth3 enabled
```



There will be 2 files generated, a command file (.cmd) which is the sent to the DataPower via SSH and the out file (.txt) that is generated during the execute.``
