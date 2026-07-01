using System;
using System.Security.Cryptography;
using System.Text;

/// <summary>
/// 密码加密工具类（PBKDF2算法，系统自带，无需任何包）
/// </summary>
public static class PasswordHelper
{
    // 配置参数（可根据需要调整，越高越安全但越慢）
    private const int SaltSize = 16; // 盐的字节数
    private const int HashSize = 32; // 哈希值的字节数
    private const int Iterations = 10000; // 迭代次数（推荐10000-100000）
    private const char Separator = '$'; // 分隔符

    /// <summary>
    /// 加密密码，返回格式：迭代次数$盐$哈希值
    /// </summary>
    public static string HashPassword(string password)
    {
        if (string.IsNullOrEmpty(password))
            throw new ArgumentNullException(nameof(password));

        // 生成安全随机盐
        using (var rng = new RNGCryptoServiceProvider())
        {
            byte[] salt = new byte[SaltSize];
            rng.GetBytes(salt);

            // 使用PBKDF2生成哈希
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations))
            {
                byte[] hash = pbkdf2.GetBytes(HashSize);

                // 组合成存储字符串：迭代次数$盐Base64$哈希Base64
                return $"{Iterations}{Separator}{Convert.ToBase64String(salt)}{Separator}{Convert.ToBase64String(hash)}";
            }
        }
    }

    /// <summary>
    /// 验证密码是否正确
    /// </summary>
    public static bool VerifyPassword(string password, string storedHash)
    {
        if (string.IsNullOrEmpty(password))
            throw new ArgumentNullException(nameof(password));
        if (string.IsNullOrEmpty(storedHash))
            return false;

        // 解析存储的字符串
        string[] parts = storedHash.Split(Separator);
        if (parts.Length != 3)
            return false; // 不是我们的加密格式

        try
        {
            int iterations = int.Parse(parts[0]);
            byte[] salt = Convert.FromBase64String(parts[1]);
            byte[] storedHashBytes = Convert.FromBase64String(parts[2]);

            // 用相同参数重新计算哈希
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations))
            {
                byte[] computedHash = pbkdf2.GetBytes(HashSize);

                // 安全比较（防止时序攻击）
                return SlowEquals(storedHashBytes, computedHash);
            }
        }
        catch
        {
            return false; // 格式错误，验证失败
        }
    }

    /// <summary>
    /// 安全的字节数组比较（防止时序攻击）
    /// </summary>
    private static bool SlowEquals(byte[] a, byte[] b)
    {
        uint diff = (uint)a.Length ^ (uint)b.Length;
        for (int i = 0; i < a.Length && i < b.Length; i++)
            diff |= (uint)(a[i] ^ b[i]);
        return diff == 0;
    }

    /// <summary>
    /// 检查密码是否是明文格式（用于自动迁移现有用户）
    /// </summary>
    public static bool IsPlainTextPassword(string storedPassword)
    {
        return !storedPassword.Contains(Separator.ToString());
    }
}