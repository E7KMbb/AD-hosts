#!/system/bin/sh
# 不要假设您的模块将位于何处。
# 如果您需要知道此脚本和模块的放置位置，请使用$MODDIR
# 这将确保您的模块仍能正常工作
# 即使Magisk将来更改其挂载点
MODDIR=${0%/*}

# 此脚本将在late_start service 模式执行
wait_count=0
until [ $(getprop sys.boot_completed) -eq 1 ] && [ -d "/sdcard" ]; do
  sleep 2
  wait_count=$((${wait_count} + 1))
  if [ ${wait_count} -ge 100 ] ; then
    exit 0
  fi
done

work_dir=/sdcard/Android/ADhosts
curdate="`date +%Y-%m-%d,%H:%M:%S`"

if [ ! -d $work_dir ];then
   mkdir -p $work_dir
fi
if [ ! -e $work_dir/update.log ];then
   touch $work_dir/update.log
   echo "paceholder" >> $work_dir/update.log
   sed -i "G;G;G;G;G" $work_dir/update.log
   sed -i '1d' $work_dir/update.log
fi
if [ ! -e $work_dir/Start.sh ];then
   touch $work_dir/Start.sh
   echo "# 手动更新，请使用root权限执行" >> $work_dir/Start.sh
   echo "sh /data/adb/modules/AD-Hosts/service.sh" >> $work_dir/Start.sh
fi

hosts_link=$(grep hosts_link $MODDIR/select.txt | awk -F '=' '{print $2}')
if [ $hosts_link = "true" ]; then
   ADhosts_link="https://raw.githubusercontent.com/E7KMbb/AD-hosts/master/system/etc/hosts"
elif [ $hosts_link = "false" ]; then
   ADhosts_link="https://aisauce.coding.net/p/ad-hosts/d/ad-hosts/git/raw/master/system/etc/hosts"
else
   echo "Error: 地址错误" >> $work_dir/update.log
   exit 0
fi

install_mod=$(grep install_mod $MODDIR/select.txt | awk -F '=' '{print $2}')
if [ $install_mod = "true" ]; then
   ADhosts_dir=$MODDIR/system/etc
elif [ $install_mod = "false" ]; then
   ADhosts_dir=/system/etc
else
   echo "Error: 模式错误" >> $work_dir/update.log
   exit 0
fi

if $(curl -V > /dev/null 2>&1) ; then
    for i in $(seq 1 20); do
    if curl "${ADhosts_link}" -k -L -o "$work_dir/hosts" >&2; then
    break;
    fi
    sleep 2
    if [[ $i == 20 ]]; then
    echo "curl连接失败,更新失败: $curdate" >> $work_dir/update.log
    rm -rf $work_dir/hosts
    exit 0
    fi
    done
elif $(wget --help > /dev/null 2>&1) ; then
      for i in $(seq 1 5); do
      if wget --no-check-certificate ${ADhosts_link} -O $work_dir/hosts; then
      break;
      fi
      if [[ $i == 5 ]]; then
      echo "wget连接,更新失败: $curdate" >> $work_dir/update.log
      rm -rf $work_dir/hosts
      exit 0
      fi
      done
else
      echo "Error: 您没有下载所需要用到的指令文件，请安装Busybox for Android NDK模块" >> $work_dir/update.log
      exit 0
fi

MIUI=$(grep MIUI $MODDIR/select.txt | awk -F '=' '{print $2}')
Tencent=$(grep Tencent $MODDIR/select.txt | awk -F '=' '{print $2}')
if [ $MIUI = "true" ]; then
   sed -i "s/<adxiaomi>/api.ad.xiaomi.com/g" $work_dir/hosts
fi
if [ $Tencent = "true" ]; then
   sed -i "s/<Tencentgamead1>/adsmind.gdtimg.com/g" $work_dir/hosts
   sed -i "s/<Tencentgamead2>/pgdt.gtimg.cn/g" $work_dir/hosts
fi

Now=$(md5sum $ADhosts_dir/hosts | awk '{print $1}')
New=$(md5sum  $work_dir/hosts | awk '{print $1}')
if [ $Now = $New ]; then
   rm -rf $work_dir/hosts
   echo "没有更新: $curdate" >> $work_dir/update.log
else
   mount -o remount,rw /
   mv -f $work_dir/hosts $ADhosts_dir/hosts
   chmod 644 $ADhosts_dir/hosts
   chown 0:0 $ADhosts_dir/hosts
   chcon u:object_r:system_file:s0 $ADhosts_dir/hosts
   mount -o remount,ro /
   echo -n "上次更新时间: $curdate" >> $work_dir/update.log
   echo "  hosts文件目录:$ADhosts_dir/hosts" >> $work_dir/update.log
   sed -i '1d' $work_dir/update.log
fi
