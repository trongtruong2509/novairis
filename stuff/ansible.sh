# ping all hosts
ansible all -m ping

# inventory yaml example
all:
  hosts:
    "all-in-one":
      ansible_host: 152.42.197.64
      ansible_user: iris
      host_key_checking: false