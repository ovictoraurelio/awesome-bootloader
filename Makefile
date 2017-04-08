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
stage1Head=1
stage1BlocksSize=1
# Settings of stage two Block on Disk
stage2Head=1
stage2BlocksSize=2
# Settings of kernel on Disk
kernelHead=3
kernelBlockSize=10

#
#				Settings of Files
#
stage1=boot
stage2=bootStage2
kernel=kernel1
kernel2=kernel2
#
#				Settings of Kernel
#

# I'm don't know...
file = $(disk)

#clear
start: clean make_disk compile1 writing_on_disk1 compile2 writing_on_disk2 hexdump launch_qemu end

welcome:

		@echo "\tWelcome to BootloaderBros setting up config\n"
clean:
		rm -f *.bin $(disk) *~
make_disk:
		dd if=/dev/zero of=$(disk) bs=$(blockSize) count=$(diskSize) status=noxfer

compile1:
		nasm -f bin $(stage1).asm -o $(stage1).bin

compile2:
		nasm -f bin $(stage2).asm -o $(stage2).bin
#		nasm $(ASMFLAGS) $(kernel).asm -o $(kernel).bin
#		nasm $(ASMFLAGS) $(kernel2).asm -o $(kernel2).bin

writing_on_disk1:
		dd if=$(stage1).bin of=$(disk) bs=$(blockSize) count=1 conv=notrunc status=noxfer
writing_on_disk2:
		dd if=$(stage2).bin of=$(disk) bs=$(blockSize) seek=$(stage2Head) count=$(stage2BlocksSize) conv=notrunc status=noxfer
#		dd if=$(kernel).bin of=$(disk) bs=$(blockSize) seek=$(kernelHead) count=$(kernelBlockSize) conv=notrunc
#		dd if=$(kernel2).bin of=$(disk) bs=$(blockSize) seek=$(kernelHead) count=$(kernelBlockSize) conv=notrunc

hexdump:
		hexdump $(file)

disasm:
		ndisasm $(stage1).asm

launch_qemu:
		qemu-system-i386 -fda $(disk)
end:
		@echo "\t --- end of BootloaderBros setting up config\n"
