package com.zjut.passcode.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    private boolean forceEncoding = true;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null && !encodingParam.trim().isEmpty()) {
            this.encoding = encodingParam;
        }
        
        String forceEncodingParam = filterConfig.getInitParameter("forceEncoding");
        if (forceEncodingParam != null) {
            this.forceEncoding = Boolean.parseBoolean(forceEncodingParam);
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // 设置请求编码
        if (this.forceEncoding || request.getCharacterEncoding() == null) {
            request.setCharacterEncoding(this.encoding);
        }
        
        // 设置响应编码
        if (this.forceEncoding || response.getCharacterEncoding() == null) {
            response.setCharacterEncoding(this.encoding);
        }
        
        // 设置响应头
        httpResponse.setHeader("Content-Type", "text/html;charset=" + this.encoding);
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // 清理资源
    }
} 