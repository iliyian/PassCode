package com.zjut.passcode.util;

import java.security.MessageDigest;
import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

public class CryptoUtil {
    
    // SM3哈希算法（使用SHA-256作为替代，实际项目中应使用真正的SM3实现）
    public static String sm3Hash(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes("UTF-8"));
            return bytesToHex(hash);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // SM4加密（使用AES作为替代，实际项目中应使用真正的SM4实现）
    public static String sm4Encrypt(String plaintext, String key) {
        try {
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
            byte[] encrypted = cipher.doFinal(plaintext.getBytes("UTF-8"));
            return Base64.getEncoder().encodeToString(encrypted);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // SM4解密
    public static String sm4Decrypt(String encryptedText, String key) {
        try {
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, secretKey);
            byte[] decrypted = cipher.doFinal(Base64.getDecoder().decode(encryptedText));
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