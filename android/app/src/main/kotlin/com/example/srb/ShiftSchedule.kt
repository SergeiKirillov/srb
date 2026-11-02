package com.example.srb

import java.time.LocalDate
import java.time.temporal.ChronoUnit

object ShiftSchedule {
    private val startDate = LocalDate.of(2026,1,1)
    private val brigades = listOf(2,1,4,3)

    fun nightBrigade(date: LocalDate): Int {
        val days = ChronoUnit.DAYS.between(startDate, date)
        val index = Math.floorMod(days, brigades.size.toLong()).toInt()
        return brigades[index]
    }

    fun dayBrigade(date: LocalDate): Int {
        return when (nightBrigade(date)){
            2 -> 4
            1 -> 3
            4 -> 2
            3 -> 1
            else -> 0
        }
    }

    fun currentBrigade(date:LocalDate, hour: Int): Int{
        return if (hour  in 7..18){
            dayBrigade(date)
        } else if (hour >= 19) {
            nightBrigade(date)
        } else {
            nightBrigade(date.minusDays(1))
        }
    }
}

