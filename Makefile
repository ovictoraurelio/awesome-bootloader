# ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥
#						Assembly is love
#
#						Makefile by BootloaderBros
#						BootloaderBros:
#   										 	Gerson Fialho @jgfn
#    											Nathan Prestwood @nmf2
#    											Victor Aurélio @vags
#
# ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥

#
#				Settings of Disk
#
disk=disk.img
blockSize=512
diskSize=100
# Settings of stage one Block on Disk
#stage1Seek=0
#stage1BlocksSize=1
# Settings of stage two Block on Disk
#stage2Seek=1
#stage2BlocksSize=2
# Settings of kernel on Disk
#kernel1Seek=2
#kernel2Seek=20
#kernelBlockSize=10

#
#				Settings of Files
#
stage1=boot
stage2=bootStage2
kernel1=kernel1
kernel2=kernel2
#
#				Settings of Kernel
#

# I'm don't know...
file = $(disk)

#clear
start: clean make_disk compiles writing_on_disk hexdump launch_qemu end

welcome:

		@echo "\tWelcome to BootloaderBros setting up config\n"
clean:
		rm -f *.bin $(disk) *~
make_disk:
		dd if=/dev/zero of=$(disk) bs=$(blockSize) count=$(diskSize) status=noxfer

compiles:
		nasm -f bin $(stage1).asm -o $(stage1).bin
		nasm -f bin $(stage2).asm -o $(stage2).bin
		nasm -f bin $(kernel1).asm -o $(kernel1).bin
		nasm -f bin $(kernel2).asm -o $(kernel2).bin

writing_on_disk:
		dd if=$(stage1).bin of=$(disk) bs=$(blockSize) count=1 conv=notrunc status=noxfer
		dd if=$(stage2).bin of=$(disk) bs=$(blockSize) seek=1 count=2 conv=notrunc status=noxfer
		dd if=$(kernel1).bin of=$(disk) bs=$(blockSize) seek=4 count=5 conv=notrunc
		dd if=$(kernel2).bin of=$(disk) bs=$(blockSize) seek=9 count=3 conv=notrunc

hexdump:
		hexdump $(file)

launch_qemu:
		qemu-system-i386 -fda $(disk)
end:
		@echo "\t --- end of BootloaderBros setting up config\n"
