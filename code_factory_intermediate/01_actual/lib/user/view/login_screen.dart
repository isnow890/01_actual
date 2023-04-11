import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

import '../../common/component/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Title(),
            _SubTitle(),
            //사이즈 2/3
            Image.asset(
              'asset/img/misc/logo.png',
              width: MediaQuery.of(context).size.width / 3 ,
              height:MediaQuery.of(context).size.height / 3 *1.3 ,
            ),
            CustomTextFormField(
              hintText: '이메일을 입력해주세요.',
              onChanged: (value) {},
            ),
            CustomTextFormField(
              hintText: '비밀번호를 입력해주세요.',
              obscureText: true,
              onChanged: (value) {},
            ),

            ElevatedButton(
              onPressed: () {},
              child: Text('로그인'),
              style: ElevatedButton.styleFrom(
                primary: PRIMARY_COLOR,

              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('회원가입'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인해주세요. \n오늘도 성공적인 주문이 되길',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
