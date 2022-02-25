require 'pathname'

puts "开始加固>>>>>>>>>>>>>>>>>>>>>>"

### 创建build文件夹，就是和签名之后的包
print <<`EOC`

if [ ! -d "build" ]; then
    mkdir build
  fi
EOC

### 开始加固
def startJiagGu

 ### 先登录(首次登录需要)
    # system("java -jar jiagu.jar -login 360U2879691448 xxxxxxx")
    # system("java -jar jiagu.jar -login 18100173445 xxxxxx")
    # 执行加固命令
    system("sh jiagu.sh oapk")

    if isHasOApk    
        puts "加固完成,开始重签名>>>>>>>>>>>>>>>>>>>>>>" 
        system("pushd custom_sign/debug&&sh signer.sh&&popd")
        system("pushd custom_sign/emum&&sh signer.sh&&popd")
        system("pushd custom_sign/release&&sh signer.sh&&popd")

### (下面的方式，会创建子进程去执行，无法同步shell的日志)
# 执行加固命令
# print <<`EOC`
# sh jiagu.sh oapk
# EOC

# print <<`EOC`
#     pushd custom_sign/debug
#     sh signer.sh 
#     popd
#     pushd custom_sign/emum
#     sh signer.sh 
#     popd
#     pushd custom_sign/release
#     sh signer.sh 
#     popd
# EOC


    if isHasBuildApk
        puts "签名完毕>>>>>>>>>>>>>>>>>>>>>>"
print <<`EOC`
    open build
EOC
    else
        puts ">>>>>>>>>>>>>>>>>>>>>>重签名失败!!!!!"
    end

    else
        puts ">>>>>>>>>>>>>>>>>>>>>>请在oApk中添加apk!!!!!!!!!!"
    end

end 

### 判断oapk中是否有apk包
def isHasOApk 
    fileApks = Dir.entries("oapk")
    i = 0
    hasApk=false
    while i < fileApks.size do
        name = String.new(fileApks.at(i))
        if name.include? ".apk"
            hasApk = true
        end
        i +=1
    end

    return hasApk
end

### 判断build中是否有apk包
def isHasBuildApk 

    fileApks = Dir.entries("build")
    i = 0
    hasApk=false
    while i < fileApks.size do
        name = String.new(fileApks.at(i))
        if name.include? ".apk"
            hasApk = true
        end
        i +=1
    end

    return hasApk
end

### 执行
startJiagGu