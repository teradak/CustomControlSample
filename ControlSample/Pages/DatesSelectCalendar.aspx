﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DatesSelectCalendar.aspx.cs" Inherits="ControlSample.Pages.DatesSelectCalendar" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style type="text/css">
        table.calendar_button {
            border: #dddddd solid 1px;
            border-collapse: collapse;
            line-height: 1em;
            float: left;
            margin: 5px;
        }

            table.calendar_button th {
                border: #dddddd solid 1px;
                background-color: #162F6B;
                padding: 5px;
                color: #FFFFFF;
                font-size: 0.9em;
                text-align: center;
            }

            table.calendar_button td {
                border: #dddddd solid 1px;
                padding: 10px;
                text-align: center;
                cursor: pointer;
            }

        table td:hover {
            background-color: #FFF09E;
        }

        /**************************
         * ボタン用
         **************************/
        .calendar_button a {
            color: #FFFFFF;
            text-decoration: none;
            font-weight: normal;
            display: inline-block;
            background-color: #878787;
            padding: 5px;
            border-radius: 3px;
        }

            .calendar_button a:hover {
                background-color: #9E9E9E;
            }
    </style>

    <div>

        <div class="datesSelecter"></div>
        
        <div style="clear:both;" />
        <textarea id="days" rows="10" cols="100"></textarea>

    </div>


    <script type="text/javascript">

        (function ($) {
            $.fn.cehckcalendar = function (options) {
                var settings = $.extend({
                    'week': ["日", "月", "火", "水", "木", "金", "土"],
                    'roop': 3,
                    'prefix': 'mycld_',   //カレンダーで使われる変数名 他と被らないようユニークに
                    'delimiter': '-',        //送信時の日付の区切り文字 yyy/mm/dd
                    'td_on': '#B3D39B',  //日付をONにしたときの背景色
                    'td_off': '#FFFFFF',  //日付をOFFにしたときの背景色
                    'send': 'days'      //postするときのinputのid <input type="hidden" id="days" name="days" >
                }, options);

                $(this).html('');//カレンダー展開場所の中身をクリア

                var $div = $(this);
                var str_Date = null;
                var end_Date = null;

                var class_td = settings.prefix + 'td';
                var class_month_on = settings.prefix + 'month_on';
                var class_month_off = settings.prefix + 'month_off';

                /*
                 * 開始日を設定
                 */
                if (settings.start) {
                    var s_Date = settings.start.split("-");
                    str_Date = new Date(s_Date[0], s_Date[1] - 1, 1);
                } else {
                    var sdate = new Date();
                    var s_yy = sdate.getFullYear();
                    var s_mm = sdate.getMonth() + 1;
                    var s_dd = sdate.getDate();
                    str_Date = new Date(s_yy, s_mm - 1, s_dd);
                }

                var y = str_Date.getFullYear();
                var m = str_Date.getMonth() + 1;

                /*
                 * 日付をクリックしたら背景色を変更する
                 */
                $(document).on('click', '.' + class_td, function () {
                    var flag = $(this).data("flag");
                    if (flag == 'on') {
                        $(this).css({ 'background-color': settings.td_off });
                        $(this).data("flag", "off");
                    } else if (flag == 'off') {
                        $(this).css({ 'background-color': settings.td_on });
                        $(this).data("flag", "on");
                    }
                    getDate();
                });

                /*
                 * 全選択
                 */
                $(document).on('click', '#' + class_month_on, function (e) {
                    $(this).parents('table').find('td').css({ 'background-color': settings.td_on });
                    $(this).parents('table').find('td').data("flag", "on");
                    getDate();
                    e.preventDefault();
                });

                /*
                 * 全解除
                 */
                $(document).on('click', '#' + class_month_off, function (e) {
                    $(this).parents('table').find('td').css({ 'background-color': settings.td_off });
                    $(this).parents('table').find('td').data("flag", "off");
                    getDate();
                    e.preventDefault();
                });


                /*
                 * 選択した日付を得る
                 */
                var getDate = function () {
                    var data = '';
                    $div.find("td").each(function () {
                        var flag = $(this).data('flag');
                        if (flag == 'on' && $(this).text()) { //空白日は除外
                            var id = $(this).attr('id');
                            id = id.replace(settings.prefix, ""); //prefixを消して日付だけにする
                            data += id + ',';
                        }
                    });
                    data = data.slice(0, -1); //末尾のカンマを取り除く

                    $("#" + settings.send).val(data); //inputのhiddenへ
                };

                /*
                 * カレンダー展開
                 */
                var Calendar = function (obj, yyyy, mmmm) {
                    var week = settings.week;
                    var html = '';

                    for (var i = 0; i < settings.roop; i++) {
                        var sdate = new Date(yyyy, (mmmm - 1) + i, 1);
                        var s_yy = sdate.getFullYear(); //年
                        var s_mm = sdate.getMonth() + 1;  //月
                        //var s_dd  = sdate.getDate();
                        var blank = sdate.getDay() | 0;           //月始めの空白欄数
                        var last = lastDay(s_yy, s_mm) | 0;        //月末の日
                        var cal = Math.ceil((blank + last) / 7); //行数を求める

                        var table_ID = settings.prefix + '' + s_yy + '' + s_mm;

                        html += '<table class="calendar_button" id="' + table_ID + '">';
                        html += '  <tr>';
                        html += '    <th colspan="7">' + s_yy + '/' + s_mm + ' &nbsp; <a href="#" id="' + class_month_on + '">全選択</a> <a href="#" id="' + class_month_off + '">解除</a></th>';
                        html += '  </tr>';

                        html += '<tr>';
                        html += '  <th>' + settings.week[0] + '</th>';
                        html += '  <th>' + settings.week[1] + '</th>';
                        html += '  <th>' + settings.week[2] + '</th>';
                        html += '  <th>' + settings.week[3] + '</th>';
                        html += '  <th>' + settings.week[4] + '</th>';
                        html += '  <th>' + settings.week[5] + '</th>';
                        html += '  <th>' + settings.week[6] + '</th>';
                        html += '</tr>';

                        //settings.prefix   delimiter

                        //行数分をループ
                        var setDay = 0;
                        for (var r = 0; r < cal; r++) {
                            html += '<tr>';
                            //一週間分をループ
                            for (var d = 0; d < 7; d++) {
                                var day = '';
                                var ymd = '';
                                if (r == 0 && d < blank) {
                                    day = '';
                                } else {
                                    setDay++;
                                    if (setDay <= last) {
                                        day = setDay;
                                        ymd = s_yy + '' + settings.delimiter + '' + s_mm + '' + settings.delimiter + '' + setDay;
                                    } else {
                                        day = '';
                                    }
                                }
                                var id = settings.prefix + '' + ymd;
                                html += '  <td data-flag="off" class="' + class_td + '" id="' + id + '">' + day + '</td>';
                            }
                            html += '</tr>';
                        }
                        html += '</table>';
                    }

                    obj.html(html);//HTMLを挿入

                };

                /*
                 * 月末を得る
                 */
                var lastDay = function (y, m) {
                    var dt = new Date(y, m, 0);
                    return dt.getDate();
                };

                return Calendar($(this), y, m);
            };
        })(jQuery);


    </script>

    <script type="text/javascript">
        $(".datesSelecter").cehckcalendar()
    </script>
</asp:Content>
