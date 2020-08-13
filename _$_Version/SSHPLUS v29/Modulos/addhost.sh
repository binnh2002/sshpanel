#!/bin/bash
if [ -d "/etc/squid/" ]; then
    payload="/etc/squid/payload.txt"
elif [ -d "/etc/squid3/" ]; then
	payload="/etc/squid3/payload.txt"
fi
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-10s\n' "Thêm máy chủ vào Squid Proxy" ; tput sgr0
if [ ! -f "$payload" ]
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Không tìm thấy tệp $ Payload" ; tput sgr0
	exit 1
else
	tput setaf 2 ; tput bold ; echo ""; echo "Các miền hiện tại trong tệp $payload:" ; tput sgr0
	tput setaf 3 ; tput bold ; echo "" ; cat $payload ; echo "" ; tput sgr0
	read -p "Nhập miền bạn muốn thêm vào danh sách: " host
	if [[ -z $host ]]
	then
		tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Bạn đã nhập một miền trống hoặc không tồn tại!" ; echo "" ; tput sgr0
		exit 1
	else
		if [[ `grep -c "^$host" $payload` -eq 1 ]]
		then
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Miền $host đã tồn tại trong tệp $payload" ; echo "" ; tput sgr0
			exit 1
		else
			if [[ $host != \.* ]]
			then
				tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Bạn phải thêm miền bắt đầu bằng dấu chấm!" ; echo "Ví dụ: google.com" ; echo "Không cần thêm miền phụ cho các miền đã có trong tệp" ; echo "Nghĩa là, không cần thiết phải thêm recargawap.claro.com.br" ; echo "nếu miền .claro.com.br đã có trong tệp." ; echo ""; tput sgr0
				exit 1
			else
				echo "$host" >> $payload && grep -v "^$" $payload > /tmp/a && mv /tmp/a $payload
				tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "Đã cập nhật tệp $Payload, đã thêm miền thành công:" ; tput sgr0
				tput setaf 3 ; tput bold ; echo "" ; cat $payload ; echo "" ; tput sgr0
				if [ ! -f "/etc/init.d/squid3" ]
				then
					service squid3 reload
				elif [ ! -f "/etc/init.d/squid" ]
				then
					service squid reload
				fi	
				tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "Squid Proxy đã được tải lại thành công!" ; echo "" ; tput sgr0
				exit 1
			fi
		fi
	fi
fi