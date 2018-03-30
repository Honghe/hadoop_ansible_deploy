# hadoop_ansible_deploy
Hadoop Ansible 3.0 Deploy
Only for CentOS 7 target host now.

## TODO
- [x] ssh-copy-id from namenode to all cluster nodes
- [ ] download built isa-l tar instead of build isa-l on each node.(ldconfig)
- [ ] check `hadoop checknative -a` on each node.
- [ ] ntp
- [ ] Reconstruct namenode hardcode

## Manual
1. Modify hosts
2. Run `./ssh-copy-id.sh` first
3. ansible-playbook site.yml
