#原始apk名称
orignalApk="";
#对齐之后的apk名称
zipalignoutApk="zipalignout.apk"
#加固之后的路径
jiaguApkPath="";
#签名文件路径
keystorePath="../../sign.keystore"
#当前路径 $1第一个参数是文件名称
path=$1
files=$(ls $path)
#获取当前原始apk的名称
for filename in $files
do
     if [[ $filename =~ ".apk" ]]
     then
         orignalApk=$filename;
         
         jiaguApkPath="../../build/"${orignalApk%%.apk*}"_sign.apk"
#         echo $orignalApk
#         echo $jiaguApk
     fi
done
if [[ -z $jiaguApkPath ]];
     then
          echo ">>>>>>>>>>>>>>>>>>>>>>预发环境没有已经加固的apk"
          exit
     else
          echo "预发环境开始签名>>>>>>>>>>>>>>>>>>>>>>"
fi


##先用zipalign将安装包对齐
zipalign -v -p 4 ${orignalApk} ${zipalignoutApk}
#使用apksigner进行签名
apksigner sign --ks $keystorePath \
--ks-pass pass:root123   \
--v1-signing-enabled true \
--v2-signing-enabled true \
--v3-signing-enabled false \
--v4-signing-enabled false \
--out ${jiaguApkPath} ${zipalignoutApk}
#删除zipalignout.apk
rm -rf ${zipalignoutApk}
##校验检测
apksigner verify -v ${jiaguApkPath}