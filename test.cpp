 #include <iostream>
 #include <openssl/ase.h>
 
 
void createTestData(QByteArray& data, int size)
{
    data.resize(size);
    for (int i = 0; i < size; i++)
    {
        data[i] = i % 128;
    }
}

void testAES(const QByteArray& data)
{
    
    QByteArray simpleText = data;
    QByteArray encryptText; //定义加密
    QByteArray decryptText; //定义解密

    QByteArray key = QByteArray::fromHex("8cc72b05705d5c46f412af8cbed55aad");
    QByteArray ivec = QByteArray::fromHex("667b02a85c61c786def4521b060265e8");

    // AES ofb128模式加密验证
    AES aes;
    aes.ofb128_encrypt(simpleText, encryptText, key, ivec, true);     // 加密
    aes.ofb128_encrypt(encryptText, decryptText, key, ivec, false);  // 解密
    qDebug() << "AES ofb128 encrypt verify" << ((decryptText == simpleText) ? "succeeded" : "failed");
}

int main(int argc, char *argv[])
{
    
    QCoreApplication a(argc, argv);

    // 产生1MB+3B的测试数据，为了使该测试数据长度，不为8或16的整数倍
    QByteArray data;
    createTestData(data, 1*1024*1024+3);

    // 测试AES
    testAES(data);     // 测试，直接调用OpenSSL中AES算法函数

    return a.exec();
}