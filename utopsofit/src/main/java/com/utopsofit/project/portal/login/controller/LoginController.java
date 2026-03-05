package com.utopsofit.project.portal.login.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 로그인 컨트롤러
 */
@Controller
public class LoginController {

    /** 로그인 페이지 */
    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String error,
                            @RequestParam(required = false) String logout,
                            @RequestParam(required = false) String expired,
                            Model model) {
        if (error != null) {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
        }
        if (logout != null) {
            model.addAttribute("logoutMsg", "로그아웃 되었습니다.");
        }
        if (expired != null) {
            model.addAttribute("errorMsg", "세션이 만료되었습니다. 다시 로그인해 주세요.");
        }
        return "portal/login/login";
    }
}
