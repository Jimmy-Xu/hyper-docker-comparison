fork from https://github.com/thewmf/kvm-docker-comparison

######################################################
# Prepare
######################################################
cd common/vm
make

cd ../../Stream
./doit.sh

#will build a stream.exe
ll bin
	-rwxrwxr-x 1 xjimmy xjimmy 57070 Jul  8 21:39 stream.exe*

#will build a docker image(for docker and hyper) : stream:latest
docker images
	REPOSITORY          TAG                  IMAGE ID            CREATED             VIRTUAL SIZE
	stream              latest               e8b99c3d8e37        38 minutes ago      458.1 MB

#will create a kvm image(for kvm): vm.img under Stream dir
ll vm.img
	-rw------- 1 xjimmy xjimmy 493813760 Jul  8 22:09 vm.img


######################################################
# manual operate host
######################################################

1) bin/stream.exe
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          14.5161       0.0463       0.0462       0.0464
	Scale:         14.4116       0.0467       0.0466       0.0468
	Add:           15.8695       0.0636       0.0634       0.0637
	Triad:         15.8508       0.0636       0.0635       0.0638

2) numactl --physcpubind=0 --localalloc bin/stream.exe
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          11.8341       0.0567       0.0567       0.0568
	Scale:         13.6862       0.0495       0.0490       0.0530
	Add:           13.8488       0.0727       0.0727       0.0728
	Triad:         13.8645       0.0727       0.0726       0.0727

	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          12.7826       0.0526       0.0525       0.0526
	Scale:         12.7004       0.0529       0.0528       0.0529
	Add:           13.0990       0.0773       0.0768       0.0808
	Triad:         13.0304       0.0773       0.0773       0.0774



######################################################
# manual operate docker
######################################################

1) docker run --memory=4096m --cpuset-cpus=0 --rm stream:latest /stream.exe
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          11.8316       0.0572       0.0567       0.0606
	Scale:         13.6289       0.0493       0.0492       0.0494
	Add:           13.8380       0.0728       0.0727       0.0729
	Triad:         13.8293       0.0728       0.0728       0.0729

2) docker run --memory=4096m --cpuset-cpus=0 --rm stream:latest bash -c "numactl --physcpubind=0 --localalloc /stream.exe"
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          11.9373       0.0563       0.0562       0.0564
	Scale:         13.6525       0.0492       0.0492       0.0493
	Add:           13.8871       0.0726       0.0725       0.0726
	Triad:         13.8794       0.0730       0.0725       0.0765

3) numactl --physcpubind=0 --localalloc docker run --memory=4096m --cpuset-cpus=0 --rm stream:latest
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          11.9300       0.0564       0.0563       0.0564
	Scale:         13.6292       0.0493       0.0492       0.0494
	Add:           13.8300       0.0729       0.0728       0.0729
	Triad:         13.8334       0.0733       0.0728       0.0768

	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          12.6673       0.0530       0.0530       0.0531
	Scale:         12.6237       0.0537       0.0532       0.0571
	Add:           12.9774       0.0776       0.0776       0.0777
	Triad:         12.8701       0.0787       0.0782       0.0822


4) numactl --physcpubind=0 --localalloc docker run --memory=4096m --cpuset-cpus=0 --rm stream:latest bash -c "numactl --physcpubind=0 --localalloc /stream.exe"
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          11.8427       0.0571       0.0567       0.0605
	Scale:         13.6112       0.0494       0.0493       0.0494
	Add:           13.8521       0.0727       0.0727       0.0728
	Triad:         13.8611       0.0727       0.0726       0.0728


######################################################
# manual operate hyper
######################################################

sudo hyper run --cpu=1 --memory=4096 stream:latest /stream.exe
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          13.7948       0.0489       0.0486       0.0495
	Scale:         13.8767       0.0487       0.0484       0.0494
	Add:           15.6341       0.0648       0.0644       0.0655
	Triad:         15.6448       0.0647       0.0643       0.0657

sudo hyper run --cpu=1 --memory=4096 stream:latest bash -c "numactl --physcpubind=0 --localalloc /stream.exe"
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          13.9166       0.0488       0.0482       0.0495
	Scale:         14.0005       0.0485       0.0479       0.0495
	Add:           15.7822       0.0644       0.0638       0.0656
	Triad:         15.7747       0.0644       0.0638       0.0655

sudo numactl --physcpubind=0 --localalloc hyper run --cpu=1 --memory=4096 stream:latest /stream.exe
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          13.8752       0.0489       0.0484       0.0492
	Scale:         13.9487       0.0486       0.0481       0.0490
	Add:           15.6383       0.0649       0.0644       0.0656
	Triad:         15.6533       0.0648       0.0643       0.0653

sudo numactl --physcpubind=0 --localalloc hyper run --cpu=1 --memory=4096 stream:latest bash -c "numactl --physcpubind=0 --localalloc /stream.exe"
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          13.8646       0.0488       0.0484       0.0491
	Scale:         13.9285       0.0485       0.0482       0.0490
	Add:           15.7193       0.0642       0.0640       0.0646
	Triad:         15.7407       0.0643       0.0640       0.0645


## test min bootable startup mem
sudo hyper run --cpu=1 --memory=28 ubuntu  top -b -n1
	POD id is pod-PdDPRppTte
	top - 09:07:48 up 0 min,  0 users,  load average: 0.00, 0.00, 0.00
	Tasks:   2 total,   1 running,   1 sleeping,   0 stopped,   0 zombie
	%Cpu(s):  0.0 us, 31.0 sy,  0.0 ni, 69.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
	KiB Mem:     19520 total,    11628 used,     7892 free,        0 buffers
	KiB Swap:        0 total,        0 used,        0 free.     4580 cached Mem


######################################################
# manual operate VM
######################################################

cd Stream

## run VM
PORT=2201
cp vm.img vm-test.img; sudo kvm -net nic -net user -hda vm-test.img -hdb ../common/vm/seed.img -m 4G -smp 1 -nographic -redir :${PORT}::22

## ssh options
SSHOPTS=" -i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"

## copy file to VM
rsync -a -e "ssh -p${PORT} $SSHOPTS" ./bin/ spyre@localhost:~

## ssh to VM
ssh -p${PORT} $SSHOPTS spyre@localhost

## run test
numactl --physcpubind=0 --localalloc ./stream.exe

## shut down the VM
ssh $SSHOPTS spyre@localhost sudo shutdown -h now

----------------------------------------------------------

## test min bootable startup mem

SSHOPTS=" -i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60" 
PORT=2202; 

#cp ../common/vm/ubuntu-14.04-server-cloudimg-amd64-disk1.img vm-min.img; 
cp ../common/vm/cirros-0.3.3-x86_64-disk.img vm-min.img;
sudo kvm -net nic -net user -hda vm-min.img -hdb ../common/vm/seed.img -m 60M -smp 1 -nographic -redir :${PORT}::22 

ssh -p${PORT} $SSHOPTS spyre@localhost top -b -n1 | grep "KiB Mem:"

ssh -p${PORT} $SSHOPTS spyre@localhost dmesg -s 131072 > ktime 
/usr/src/linux-headers-3.13.0-55/scripts/show_delta ktime 


##for cirros - passwd: cubswin:)
 - http://docs.openstack.org/zh_CN/image-guide/content/ch_obtaining_images.html

ssh -p${PORT} $SSHOPTS cirros@localhost "mkdir -p ~/.ssh"
#rsync -a -e "ssh -p${PORT} " ../common/{authorized_keys,id_rsa,id_rsa.pub} cirros@localhost:~/.ssh
scp ../common/{authorized_keys,id_rsa,id_rsa.pub} cirros@localhost:${PORT}:~/.ssh
ssh -p${PORT} $SSHOPTS cirros@localhost "chmod 400 ~/.ssh/{authorized_keys,id_rsa}"

ssh -p${PORT} $SSHOPTS cirros@localhost dmesg


-------------------------------------------------------------------

1) cp vm.img vm-test.img; sudo kvm -net nic -net user -hda vm-test.img -hdb ../common/vm/seed.img -m 4G -smp 1 -nographic -redir :2222::22

1.1) ssh $SSHOPTS spyre@localhost ./stream.exe
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          12.4843       0.0539       0.0538       0.0543
	Scale:         13.3873       0.0502       0.0501       0.0503
	Add:           13.9072       0.0725       0.0724       0.0725
	Triad:         13.8086       0.0731       0.0729       0.0740

1.2) ssh $SSHOPTS spyre@localhost numactl --physcpubind=0 --localalloc ./stream.exe
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          11.9996       0.0564       0.0559       0.0599
	Scale:         13.5185       0.0497       0.0496       0.0497
	Add:           13.8029       0.0730       0.0729       0.0731
	Triad:         13.7608       0.0733       0.0732       0.0735

2) cp vm.img vm-test.img; sudo numactl --physcpubind=0 --localalloc kvm -net nic -net user -hda vm-test.img -hdb ../common/vm/seed.img -m 4G -smp 1 -nographic -redir :2222::22

2.1) ssh $SSHOPTS spyre@localhost ./stream.exe
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          11.8164       0.0569       0.0568       0.0573
	Scale:         13.6473       0.0501       0.0492       0.0533
	Add:           13.8654       0.1420       0.0726       0.6968
	Triad:         13.8653       0.0727       0.0726       0.0729

	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          12.5552       0.0535       0.0535       0.0536
	Scale:         12.6590       0.0531       0.0530       0.0531
	Add:           12.9089       0.0781       0.0780       0.0783
	Triad:         12.8041       0.0792       0.0786       0.0826


2.2) ssh $SSHOPTS spyre@localhost numactl --physcpubind=0 --localalloc ./stream.exe
	Function      Rate (GB/s)   Avg time     Min time     Max time
	Copy:          12.3471       0.0545       0.0544       0.0548
	Scale:         13.4185       0.0501       0.0500       0.0502
	Add:           13.8655       0.0727       0.0726       0.0727
	Triad:         13.8689       0.0731       0.0726       0.0766

#######################################################################

rm tmp* -rf
#------------------------------------
# bulk create VM
for i in `seq 1 105`
do
	IMG=`mktemp tmpXXX.img`
	echo "create vm($IMG):"$i
	PORT=$((2200+i))
	cp vm.img ${IMG};
	echo "sudo kvm -net nic -net user -hda ${IMG} -hdb ../common/vm/seed.img -m 512M -smp 1 -nographic -redir :${PORT}::22 >results/$IMG.log &"
	sleep 5
done
echo "total vm"
ps -ef | grep qemu | grep -v grep |wc -l 


#------------------------------------
#bulk check VM
SSHOPTS=" -i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"
PORT_LST=$(sudo netstat -tnopl  | grep qemu | sort | grep 22 | awk '{print $4}' | cut -d":" -f2
)
for i in ${PORT_LST}
do
	ssh -p$i $SSHOPTS spyre@localhost bash -c "TERM=xterm;top -b -n1 | grep 'KiB Mem'"
done



#------------------------------------
#bulk shutdown VM
SSHOPTS=" -i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"
for i in `seq 1 105`
do
	PORT=$((2200+i))
	echo "PORT:${PORT}"
	ssh $SSHOPTS spyre@localhost -p${PORT} sudo shutdown -h now
	sleep 1
done




-- result ---------------------------------------------

each vm: 1cpu + 512MB

#[normal kvm]:

sudo kvm -net nic -net user -hda tmpYCR.img -hdb ../common/vm/seed.img -m 512M -smp 1 -nographic -redir :2250::22
	qemu-system-x86_64 -enable-kvm -net nic -net user -hda tmpYCR.img -hdb ../common/vm/seed.img -m 512M -smp 1 -nographic -redir :2250::22

> QEMU process memory usage(MiB): ( 105 qemu process )
|  -  | min | max | avg |
| --- | --- | --- | --- |
|RSS(VmRSS) |    70 |   184 |   156 |
|VSZ(VmSize)|   928 |   928 |   928 |

> memory usage in container (MiB): ( 105 running container )
|  -  | min | max | avg |
| --- | --- | --- | --- |
|Total|   490 |   490 |   490 |
|Used |    343 |    343 |    343 |
|Free |   146 |   146 |   146 |

create vm(tmp3vy.img):106
Cannot set up guest memory 'pc.ram': Cannot allocate memory

16GB => 105 vm

######################################################
# ---------------- hyper ----------------------------#
######################################################


sudo hyper list pod | grep hyper-stream | grep -v "pod-.*running" | awk '{print $1}' | xargs -i sudo hyper stop {}
sudo hyper list pod | grep hyper-stream | grep -v "pod-.*running" | awk '{print $1}' | xargs -i sudo hyper rm {}
sudo hyper list | grep hyper-stream | grep running | wc -l

# bulk create hyper pod
for i in `seq 1 251`
do
	echo "create pod :"$i
	sudo hyper pod hyper-stream.pod
	sleep 2
done
echo "total hyper pod"
sudo hyper list | grep running | wc -l


# bulk check container
for i in `sudo hyper list container | grep running | awk '{print $1}'`
do
	echo "check container :"$i
	sudo hyper exec $i uptime
done


> QEMU process memory usage(MiB): ( 252 qemu process )
|  -  | min | max | avg |
| --- | --- | --- | --- |
|RSS(VmRSS) |    61 |    75 |    69 |
|VSZ(VmSize)|   994 |  1066 |   995 |

> memory usage in container (MiB): ( 252 running container )
|  -  | min | max | avg |
| --- | --- | --- | --- |
|Total|   498 |   498 |   498 |
|Used |    14 |    14 |    14 |
|Free |   484 |   484 |   484 |

16GB => 251 hyper pod


$ sudo hyper pod hyper-stream.pod
hyper ERROR: An error occurred trying to connect: Post http:///var/run/hyper.sock/v0.2.1/pod/run?podArgs=%7B%0A++%22tty%22%3A+true%2C%0A++%22volumes%22%3A+%5B%5D%2C%0A++%22files%22%3A+%5B%5D%2C%0A++%22resource%22%3A+%7B%0A++++%22memory%22%3A+512%2C%0A++++%22vcpu%22%3A+1%0A++%7D%2C%0A++%22containers%22%3A+%5B%0A++++%7B%0A++++++%22command%22%3A+%5B%0A++++++++%22%2Fbin%2Fbash%22%0A++++++%5D%2C%0A++++++%22workdir%22%3A+%22%2F%22%2C%0A++++++%22image%22%3A+%22hyper%3Astream%22%2C%0A++++++%22name%22%3A+%22hyper-stream%22%0A++++%7D%0A++%5D%2C%0A++%22id%22%3A+%22hyper-stream%22%0A%7D%0A%0A: EOF

