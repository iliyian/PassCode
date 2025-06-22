package com.zjut.passcode.util;

import java.util.Base64;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;

import org.bouncycastle.crypto.digests.SM3Digest;
import org.bouncycastle.crypto.engines.SM4Engine;
import org.bouncycastle.crypto.paddings.PKCS7Padding;
import org.bouncycastle.crypto.paddings.PaddedBufferedBlockCipher;
import org.bouncycastle.crypto.params.KeyParameter;

public class CryptoUtil {
    
    // SM3哈希算法（真正实现）
    public static String sm3Hash(String input) {
        try {
            System.out.println("INFO: Hashing input: " + input);
            SM3Digest digest = new SM3Digest();
            byte[] inputBytes = input.getBytes("UTF-8");
            digest.update(inputBytes, 0, inputBytes.length);
            byte[] hash = new byte[digest.getDigestSize()];
            digest.doFinal(hash, 0);
            String hashResult = bytesToHex(hash);
            System.out.println("INFO: Hash result: " + hashResult);
            return hashResult;
        } catch (Exception e) {
            System.out.println("ERROR: Password hashing failed");
            System.out.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    // 获取并校验SM4密钥长度
    private static byte[] getSm4KeyBytes(String key) throws Exception {
        byte[] keyBytes = key.getBytes("UTF-8");
        if (keyBytes.length != 16) {
            throw new IllegalArgumentException("SM4 key must be 16 bytes (128 bits), but got " + keyBytes.length + " bytes");
        }
        return keyBytes;
    }
    
    // SM4加密（真正实现，ECB/PKCS7Padding）
    public static String sm4Encrypt(String plaintext, String key) {
        try {
            byte[] keyBytes = getSm4KeyBytes(key);
            byte[] input = plaintext.getBytes("UTF-8");
            PaddedBufferedBlockCipher cipher = new PaddedBufferedBlockCipher(new SM4Engine(), new PKCS7Padding());
            cipher.init(true, new KeyParameter(keyBytes));
            byte[] output = new byte[cipher.getOutputSize(input.length)];
            int len = cipher.processBytes(input, 0, input.length, output, 0);
            len += cipher.doFinal(output, len);
            byte[] encrypted = new byte[len];
            System.arraycopy(output, 0, encrypted, 0, len);
            return Base64.getEncoder().encodeToString(encrypted);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // SM4解密（真正实现，ECB/PKCS7Padding）
    public static String sm4Decrypt(String encryptedText, String key) {
        try {
            byte[] keyBytes = getSm4KeyBytes(key);
            byte[] input = Base64.getDecoder().decode(encryptedText);
            PaddedBufferedBlockCipher cipher = new PaddedBufferedBlockCipher(new SM4Engine(), new PKCS7Padding());
            cipher.init(false, new KeyParameter(keyBytes));
            byte[] output = new byte[cipher.getOutputSize(input.length)];
            int len = cipher.processBytes(input, 0, input.length, output, 0);
            len += cipher.doFinal(output, len);
            byte[] decrypted = new byte[len];
            System.arraycopy(output, 0, decrypted, 0, len);
            return new String(decrypted, "UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // 生成HMAC-SM3签名
    public static String generateHmacSm3(String data) {
        try {
            String key = "campus_pass_secret_key_2024";
            String combined = key + data;
            return sm3Hash(combined);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // 生成随机密钥
    public static String generateKey() {
        try {
            KeyGenerator keyGen = KeyGenerator.getInstance("AES");
            keyGen.init(128);
            SecretKey secretKey = keyGen.generateKey();
            return Base64.getEncoder().encodeToString(secretKey.getEncoded());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // 数据脱敏处理
    public static String maskName(String name) {
        if (name == null || name.length() <= 1) {
            return name;
        }
        if (name.length() == 2) {
            return name.charAt(0) + "*" + name.charAt(1);
        } else {
            StringBuilder masked = new StringBuilder();
            masked.append(name.charAt(0));
            for (int i = 1; i < name.length() - 1; i++) {
                masked.append("*");
            }
            masked.append(name.charAt(name.length() - 1));
            return masked.toString();
        }
    }
    
    public static String maskIdCard(String idCard) {
        if (idCard == null || idCard.length() < 8) {
            return idCard;
        }
        return idCard.substring(0, 6) + "********" + idCard.substring(idCard.length() - 4);
    }
    
    public static String maskPhone(String phone) {
        if (phone == null || phone.length() < 7) {
            return phone;
        }
        return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
    }
    
    // 字节数组转十六进制字符串
    private static String bytesToHex(byte[] bytes) {
        StringBuilder result = new StringBuilder();
        for (byte b : bytes) {
            result.append(String.format("%02x", b));
        }
        return result.toString();
    }
    
    // 密码复杂度验证
    public static boolean validatePasswordComplexity(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        boolean hasDigit = false;
        boolean hasLower = false;
        boolean hasUpper = false;
        boolean hasSpecial = false;
        
        for (char c : password.toCharArray()) {
            if (Character.isDigit(c)) {
                hasDigit = true;
            } else if (Character.isLowerCase(c)) {
                hasLower = true;
            } else if (Character.isUpperCase(c)) {
                hasUpper = true;
            } else {
                hasSpecial = true;
            }
        }
        
        return hasDigit && hasLower && hasUpper && hasSpecial;
    }
} 