package com.pcwk.ehr.calendar.dao;

import java.sql.SQLException;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Repository;

import com.pcwk.ehr.board.domain.BoardVO;
import com.pcwk.ehr.calendar.domain.CalendarVO;
import com.pcwk.ehr.cmn.PcwkLogger;

@Repository
public class CalendarDaoImpl implements CalendarDao, PcwkLogger{
	
	final String NAMESPACE = "com.pcwk.ehr.calendar";
	final String DOT       = ".";
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	public CalendarDaoImpl() {}
	

	@Override
	public List<CalendarVO> doSelectMonth(CalendarVO inVO) throws SQLException, EmptyResultDataAccessException {
		List<CalendarVO> outVO = null;
		
		LOG.debug("1.param \n" + inVO.toString());
		String statement = NAMESPACE+DOT+"doSelectMonth";
		LOG.debug("2.statement \n" + statement);
		
		outVO= this.sqlSessionTemplate.selectList(statement, inVO);
		if(null != outVO) {
			LOG.debug("3.outVO \n" + outVO.toString());
		}
		return outVO;
	}

}

