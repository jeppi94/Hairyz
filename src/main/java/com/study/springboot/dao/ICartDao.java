package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.study.springboot.dto.CartDto;
import com.study.springboot.dto.MemberDto;
import com.study.springboot.dto.QDto;
import com.study.springboot.dto.QnaReplyDto;

@Mapper
public interface ICartDao
{	
	List<CartDto> getCartByMemberId(@Param("mbId") String mbId);
}
