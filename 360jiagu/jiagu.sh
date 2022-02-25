#当前路径
path=$1
files=$(ls $path)
#三种环境的apk名称
debugApkName=""
emulationApkName=""
releaseApkName=""
#三种环境加固之后的apk路径
debugJGPath=""
emulationJGPath=""
releaseJGPath=""

### 核心加固
startJiagu() {
    
     mode=$1
     inputPath=""
     outPath=""
     if [ $mode == 1 ]
     then
          echo "测试环境开始加固>>>>>>>>>>>>>>>>>>>>>>"
          inputPath=$debugApkName
          outPath=$debugJGPath
     elif [ $mode == 2 ]
     then
          echo "预发环境开始加固>>>>>>>>>>>>>>>>>>>>>>"
          inputPath=$emulationApkName
          outPath=$emulationJGPath
     else 
          echo "正式环境开始加固>>>>>>>>>>>>>>>>>>>>>>"
          inputPath=$releaseApkName
          outPath=$releaseJGPath
     fi

     pushd $outPath 
     rm -rf *.apk
     popd
     
     ### 检测加固版本是否最新
     java -jar jiagu.jar -update
     ### 导入签名(暂不导入)
     #java -jar jiagu.jar -importsign sign.keystore root123 androidTest root123
     echo "查看当前加固服务配置>>>>>>>>>>>>>>>>>>>>>>"
     ### 查看当前加固服务配置
     java -jar jiagu.jar -showconfig
     ### 加固
     java -jar jiagu.jar -jiagu $path/$inputPath $outPath 
}

### 获取apk名称和加固后路径
fetchNameAndPath() {
     #获取当前测试环境原始apk的名称
     for filename in $files
     do
          if [[ $filename =~ "-debug" ]]
          then
          debugApkName=$filename;
          if [ -n $debugApkName ]; then
          # debugJGPath="custom_sign/debug/"${debugApkName%%.apk*}"_jiagu.apk"
          debugJGPath="custom_sign/debug/"
          fi
          fi
     done

     #获取当前预发环境原始apk的名称
     for filename in $files
     do
          if [[ $filename =~ "-emulation" ]]
          then
          emulationApkName=$filename;
          #两边都要有空格
          if [ -n $emulationApkName ]; then
          # emulationJGPath="custom_sign/emum/"${emulationApkName%%.apk*}"_jiagu.apk"
          emulationJGPath="custom_sign/emum/"
          fi
          fi
     done

     #获取当前正式环境原始apk的名称
     for filename in $files
     do
          if [[ $filename =~ "-release" ]]
          then
          releaseApkName=$filename;
          if [ -n $releaseApkName ]; then
          # releaseJGPath="custom_sign/release/"${releaseApkName%%.apk*}"_jiagu.apk"
          releaseJGPath="custom_sign/release/"
          fi
          fi
     done

}

### 是否可以加固（是否存在文件）
isCanJiaguAndStart() {

     fetchNameAndPath 

     #判断测试环境开始加固
     if [[ -z $debugApkName ]];
          then
               echo ">>>>>>>>>>>>>>>>>>>>>>测试环境没有apk,无法加固"
          else
               startJiagu 1
     fi

     #判断预发环境开始加固
     if [[ -z $emulationApkName ]];
          then
               echo ">>>>>>>>>>>>>>>>>>>>>>预发环境没有apk,无法加固"
          else
               startJiagu 2
     fi

     #判断预发环境开始加固
     if [[ -z $releaseApkName ]];
          then
               echo ">>>>>>>>>>>>>>>>>>>>>>正式环境没有apk,无法加固"
          else startJiagu 3
     fi

}

### 开始执行
isCanJiaguAndStart