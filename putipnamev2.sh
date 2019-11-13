#!/bin/bash
assign_IP () {
clear
echo "*******************************************************************************"
echo "*** WELCOME IT OPS... You're about to configure IP Address and hostname...  ***"
echo "*** Please be cautious of the value that you will input. Thank you!!! by#TyroneNisaga#12 ***"
echo "*******************************************************************************"
read -p "Do you want to assign $as_ip as static?([y]es or [N]o): " REPLY
    		case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        	y|yes) 
			echo "Answer is [$REPLY] for YES. IP Address will be configured as static"
        		sudo sed -i '6s/.*/iface eth0 inet static/' /etc/network/interfaces
        		sudo sed -i "7s/.*/address $as_ip/" /etc/network/interfaces
		        sudo ifdown eth0 >&2
		        sudo ifup eth0 >&2
			sudo service networking restart >&2
		        #echo "IP Address has been configured successfully...  "
			;;
		    *)
			echo "Answer is [$REPLY] for NO. IP Address will be configured as dhcp"
		        sudo sed -i '6s/.*/iface eth0 inet dhcp/' /etc/network/interfaces
        		sudo sed -i "7s/.*/#address $as_ip/" /etc/network/interfaces
               		#sudo sed -i "8s/.*/#/" /etc/network/interfaces
        		#sudo sed -i "9s/.*/#/" /etc/network/interfaces
			sudo ifdown eth0 >&2
		        sudo ifup eth0 >&2
			sudo service networking restart >&2
			;;
		esac
}

ping_IP () {
clear
echo "*******************************************************************************"
echo "*** WELCOME IT OPS... You're about to configure IP Address and hostname...  ***"
echo "*** Please be cautious of the value that you will input. Thank you!!! by#12 ***"
echo "*******************************************************************************"
	if ping -c1 -w3 $as_ip >/dev/null 2>&1
	then		
		echo "Ping responded; IP address is already allocated..." >&2	
		assign_IP
	else
		echo "Ping did not respond; IP address either free or PC not UP...." >&2	
		assign_IP
	fi
 
}

assign_prod () {
	ping_IP        
	var=$(echo "$as_ip" | cut -d '.' -f4)
        sudo sed -i "1s/.*/PHPROD$var/" /etc/hostname
        sudo sed -i "2s/.*/127.0.1.1\tPHPROD$var/" /etc/hosts
        clear
	echo "IP Address[$as_ip] and Hostname[PHPROD$var] configured successfully."
	echo "Please restart this PC now to take effect...Thank you!!!"
	read junk
	exit
}

assign_nonprod () {
	assign_IP
	read -p "Assign a Hostname or PC Name for Non-Production PC: " as_host
	sudo sed -i "1s/.*/$as_host/" /etc/hostname
        sudo sed -i "2s/.*/127.0.1.1\t$as_host/" /etc/hosts
	clear
	echo "IP Address[DHCP] and Hostname[$as_host] configured successfully."
	echo "Please restart this PC now to take effect...Thank you!!!"
	read junk
	exit
}

# Simple bash script to assign IP and hostname by ENORYT and SWING shift
clear
echo "*******************************************************************************"
echo "*** WELCOME IT OPS... You're about to configure IP Address and hostname...  ***"
echo "*** Please be cautious of the value that you will input. Thank you!!! by#12 ***"
echo "*******************************************************************************"
read -p "Please assign a correct IP address now: " as_ip
read -p "Is IP Address[$as_ip] for Production?([y]es or [N]o): " REPLY
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) 
	assign_prod
	#echo "IP Address and Hostname has been configured successfully. To take effect, please restart this PC now.... Thank you!!!"
	return 0 ;;
        *)
	assign_nonprod
	#echo "IP Address and Hostname has been configured successfully. To take effect, please restart this PC now.... Thank you!!!"        
        return 0 ;;
    esac
