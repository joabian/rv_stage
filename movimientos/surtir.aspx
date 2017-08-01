﻿<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="surtir.aspx.vb" Inherits="movimientos_surtir" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />
    <script src="../Scripts/colorbox/colorbox.js" type="text/javascript"></script>
    <link href="../Scripts/colorbox/colorbox.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        //$('form').preventDoubleSubmission();

        //$('form').submit(function () {
        //    $('input[type=submit]', this).attr('disabled', 'disabled');
        //});

        var items = new Array;
        var codigo_tras = "";
        var qty_ajust = "";
        var start_date;

        function PrintElem(elem) {
            Popup($(elem).html());
        }

        function Popup(data) {
            var mywindow = window.open('', 'my div', 'height=400,width=600');
            mywindow.document.write('<html><head><title>my div</title>');
            /*optional stylesheet*/ //mywindow.document.write('<link rel="stylesheet" href="main.css" type="text/css" />');
            mywindow.document.write('</head><body >');
            mywindow.document.write(data);
            mywindow.document.write('</body></html>');

            mywindow.document.close(); // necessary for IE >= 10
            mywindow.focus(); // necessary for IE >= 10

            mywindow.print();
            mywindow.close();

            return true;
        }

        function addMyItem() {
            var key = event.keyCode
            if (key == "13" || key == "9") {
                additem();
                event.preventDefault();
                return false;
            }

        }

        function additem() {

            var item = $("#tbx_code_html").val().toUpperCase();
            $('#<%=lbl_pieza_lbl.ClientID%>').text(item + " : ");
            var found = "0";
            //start_date = getDateTime();
            if (start_date == undefined) {
                //alert(start_date);
                start_date = getDateTime();
            }

            //alert(item);
            //items.push(item);
            //updateitemList();

            //beep();

            var MyRows = $('table#htmlTable').find('tbody').find('tr');
            for (var i = 0; i < MyRows.length; i++) {
                var MyIndexValue = $(MyRows[i]).find('td:eq(0)').html().toUpperCase();
                //alert(MyIndexValue);
                if (item == MyIndexValue) {
                    found = "1"
                    var qty_req = parseInt($(MyRows[i]).find('td:eq(1)').html()); //100
                    var qty_surt = parseInt($(MyRows[i]).find('td:eq(2)').html()); //1
                    var qty_loc = parseInt($(MyRows[i]).find('td:eq(4)').html()); //1

                    var qty_falt = qty_req - qty_surt;
                    var qty_dispo = qty_loc - qty_surt;

                    if (qty_falt <= 0) {
                        beepError();
                    }
                        // solo puede sacar de almacen
                    else if (qty_dispo <= 0) {
                        beepError();
                    }
                    else {

                        var total = parseInt(qty_surt) + 1;
                        var totalF = parseInt(qty_falt) - 1;
                        $('#<%=lbl_pieza_qty.ClientID%>').text(total);
                        $(MyRows[i]).find('td:eq(2)').html(total);
                        $(MyRows[i]).find('td:eq(3)').html(totalF);
                        formatTable();
                        $(MyRows[i]).find('td:eq(8)').html("1");
                        beep();
                        //sortTable();
                    }
            }

        }

        if (found == "0") {
            beepError();
            $('#<%=lbl_pieza_qty.ClientID%>').text("X");
        }

        $("#tbx_code_html").val("");
        $("#tbx_code_html").focus();

    }



    function updateitemList() {
        var html_table;
        html_table = "<table><tr><th>Codigo</th><tr>"
        for (i = 0; i <= items.length - 1; i++) {
            html_table += "<tr><td>" + items[i] + "</td></tr>"
        }
        html_table += "</table>"
        //$("#scanned_items").innerHTML(html_table);

        var mydiv = document.getElementById("scanned_items");
        mydiv.innerHTML = items.toString();

    }

    function formatTable() {
        var MyRows = $('table#htmlTable').find('tbody').find('tr');
        for (var i = 0; i < MyRows.length; i++) {
            var qty_req = parseInt($(MyRows[i]).find('td:eq(1)').html());
            var qty_surt = parseInt($(MyRows[i]).find('td:eq(2)').html());
            var qty_loc = parseInt($(MyRows[i]).find('td:eq(4)').html());

            var qty_falt = qty_req - qty_surt;


            if (qty_falt == 0) {
                $(MyRows[i]).find('td').css('background-color', '#B2F728');
            } else if (qty_req > qty_loc) {
                $(MyRows[i]).find('td').css('background-color', '#FF7D7F');
            } else if (qty_surt > 0) {
                $(MyRows[i]).find('td').css('background-color', '#FFFB7D');
            } else {
                $(MyRows[i]).find('td').css('background-color', '#FFF');
            }

            $(MyRows[i]).find('td:eq(8)').html("2");

        }
    }

    function beep() {
        var sndG = new Audio("data:audio/wav;base64,//uQRAAAAWMSLwUIYAAsYkXgoQwAEaYLWfkWgAI0wWs/ItAAAGDgYtAgAyN+QWaAAihwMWm4G8QQRDiMcCBcH3Cc+CDv/7xA4Tvh9Rz/y8QADBwMWgQAZG/ILNAARQ4GLTcDeIIIhxGOBAuD7hOfBB3/94gcJ3w+o5/5eIAIAAAVwWgQAVQ2ORaIQwEMAJiDg95G4nQL7mQVWI6GwRcfsZAcsKkJvxgxEjzFUgfHoSQ9Qq7KNwqHwuB13MA4a1q/DmBrHgPcmjiGoh//EwC5nGPEmS4RcfkVKOhJf+WOgoxJclFz3kgn//dBA+ya1GhurNn8zb//9NNutNuhz31f////9vt///z+IdAEAAAK4LQIAKobHItEIYCGAExBwe8jcToF9zIKrEdDYIuP2MgOWFSE34wYiR5iqQPj0JIeoVdlG4VD4XA67mAcNa1fhzA1jwHuTRxDUQ//iYBczjHiTJcIuPyKlHQkv/LHQUYkuSi57yQT//uggfZNajQ3Vmz+Zt//+mm3Wm3Q576v////+32///5/EOgAAADVghQAAAAA//uQZAUAB1WI0PZugAAAAAoQwAAAEk3nRd2qAAAAACiDgAAAAAAABCqEEQRLCgwpBGMlJkIz8jKhGvj4k6jzRnqasNKIeoh5gI7BJaC1A1AoNBjJgbyApVS4IDlZgDU5WUAxEKDNmmALHzZp0Fkz1FMTmGFl1FMEyodIavcCAUHDWrKAIA4aa2oCgILEBupZgHvAhEBcZ6joQBxS76AgccrFlczBvKLC0QI2cBoCFvfTDAo7eoOQInqDPBtvrDEZBNYN5xwNwxQRfw8ZQ5wQVLvO8OYU+mHvFLlDh05Mdg7BT6YrRPpCBznMB2r//xKJjyyOh+cImr2/4doscwD6neZjuZR4AgAABYAAAABy1xcdQtxYBYYZdifkUDgzzXaXn98Z0oi9ILU5mBjFANmRwlVJ3/6jYDAmxaiDG3/6xjQQCCKkRb/6kg/wW+kSJ5//rLobkLSiKmqP/0ikJuDaSaSf/6JiLYLEYnW/+kXg1WRVJL/9EmQ1YZIsv/6Qzwy5qk7/+tEU0nkls3/zIUMPKNX/6yZLf+kFgAfgGyLFAUwY//uQZAUABcd5UiNPVXAAAApAAAAAE0VZQKw9ISAAACgAAAAAVQIygIElVrFkBS+Jhi+EAuu+lKAkYUEIsmEAEoMeDmCETMvfSHTGkF5RWH7kz/ESHWPAq/kcCRhqBtMdokPdM7vil7RG98A2sc7zO6ZvTdM7pmOUAZTnJW+NXxqmd41dqJ6mLTXxrPpnV8avaIf5SvL7pndPvPpndJR9Kuu8fePvuiuhorgWjp7Mf/PRjxcFCPDkW31srioCExivv9lcwKEaHsf/7ow2Fl1T/9RkXgEhYElAoCLFtMArxwivDJJ+bR1HTKJdlEoTELCIqgEwVGSQ+hIm0NbK8WXcTEI0UPoa2NbG4y2K00JEWbZavJXkYaqo9CRHS55FcZTjKEk3NKoCYUnSQ0rWxrZbFKbKIhOKPZe1cJKzZSaQrIyULHDZmV5K4xySsDRKWOruanGtjLJXFEmwaIbDLX0hIPBUQPVFVkQkDoUNfSoDgQGKPekoxeGzA4DUvnn4bxzcZrtJyipKfPNy5w+9lnXwgqsiyHNeSVpemw4bWb9psYeq//uQZBoABQt4yMVxYAIAAAkQoAAAHvYpL5m6AAgAACXDAAAAD59jblTirQe9upFsmZbpMudy7Lz1X1DYsxOOSWpfPqNX2WqktK0DMvuGwlbNj44TleLPQ+Gsfb+GOWOKJoIrWb3cIMeeON6lz2umTqMXV8Mj30yWPpjoSa9ujK8SyeJP5y5mOW1D6hvLepeveEAEDo0mgCRClOEgANv3B9a6fikgUSu/DmAMATrGx7nng5p5iimPNZsfQLYB2sDLIkzRKZOHGAaUyDcpFBSLG9MCQALgAIgQs2YunOszLSAyQYPVC2YdGGeHD2dTdJk1pAHGAWDjnkcLKFymS3RQZTInzySoBwMG0QueC3gMsCEYxUqlrcxK6k1LQQcsmyYeQPdC2YfuGPASCBkcVMQQqpVJshui1tkXQJQV0OXGAZMXSOEEBRirXbVRQW7ugq7IM7rPWSZyDlM3IuNEkxzCOJ0ny2ThNkyRai1b6ev//3dzNGzNb//4uAvHT5sURcZCFcuKLhOFs8mLAAEAt4UWAAIABAAAAAB4qbHo0tIjVkUU//uQZAwABfSFz3ZqQAAAAAngwAAAE1HjMp2qAAAAACZDgAAAD5UkTE1UgZEUExqYynN1qZvqIOREEFmBcJQkwdxiFtw0qEOkGYfRDifBui9MQg4QAHAqWtAWHoCxu1Yf4VfWLPIM2mHDFsbQEVGwyqQoQcwnfHeIkNt9YnkiaS1oizycqJrx4KOQjahZxWbcZgztj2c49nKmkId44S71j0c8eV9yDK6uPRzx5X18eDvjvQ6yKo9ZSS6l//8elePK/Lf//IInrOF/FvDoADYAGBMGb7FtErm5MXMlmPAJQVgWta7Zx2go+8xJ0UiCb8LHHdftWyLJE0QIAIsI+UbXu67dZMjmgDGCGl1H+vpF4NSDckSIkk7Vd+sxEhBQMRU8j/12UIRhzSaUdQ+rQU5kGeFxm+hb1oh6pWWmv3uvmReDl0UnvtapVaIzo1jZbf/pD6ElLqSX+rUmOQNpJFa/r+sa4e/pBlAABoAAAAA3CUgShLdGIxsY7AUABPRrgCABdDuQ5GC7DqPQCgbbJUAoRSUj+NIEig0YfyWUho1VBBBA//uQZB4ABZx5zfMakeAAAAmwAAAAF5F3P0w9GtAAACfAAAAAwLhMDmAYWMgVEG1U0FIGCBgXBXAtfMH10000EEEEEECUBYln03TTTdNBDZopopYvrTTdNa325mImNg3TTPV9q3pmY0xoO6bv3r00y+IDGid/9aaaZTGMuj9mpu9Mpio1dXrr5HERTZSmqU36A3CumzN/9Robv/Xx4v9ijkSRSNLQhAWumap82WRSBUqXStV/YcS+XVLnSS+WLDroqArFkMEsAS+eWmrUzrO0oEmE40RlMZ5+ODIkAyKAGUwZ3mVKmcamcJnMW26MRPgUw6j+LkhyHGVGYjSUUKNpuJUQoOIAyDvEyG8S5yfK6dhZc0Tx1KI/gviKL6qvvFs1+bWtaz58uUNnryq6kt5RzOCkPWlVqVX2a/EEBUdU1KrXLf40GoiiFXK///qpoiDXrOgqDR38JB0bw7SoL+ZB9o1RCkQjQ2CBYZKd/+VJxZRRZlqSkKiws0WFxUyCwsKiMy7hUVFhIaCrNQsKkTIsLivwKKigsj8XYlwt/WKi2N4d//uQRCSAAjURNIHpMZBGYiaQPSYyAAABLAAAAAAAACWAAAAApUF/Mg+0aohSIRobBAsMlO//Kk4soosy1JSFRYWaLC4qZBYWFRGZdwqKiwkNBVmoWFSJkWFxX4FFRQWR+LsS4W/rFRb/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////VEFHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU291bmRib3kuZGUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMjAwNGh0dHA6Ly93d3cuc291bmRib3kuZGUAAAAAAAAAACU=");
        sndG.play();
    }

    function beepError() {
        var sndW = new Audio("data:audio/wav;base64,UklGRpD2AABXQVZFZm10IBAAAAABAAEARKwAAIhYAQACABAAZGF0YWz2AAABpv+lAKYBpv6lA6b9pQKm/6UApgCmAKYBpv6lA6b8pQOm/6X/pQOm/KUEpvylBKb9pQKm/6X/pQOm/aUCpv+lAKYApgGm/6UBpv+lAab/pQGmAKb/pQKm/qUBpgCm/6UBpgCm/6UCpv2lAqYApv+lAqb9pQOm/aUDpv6lAKYCpvylBKb+pQCmAab/pf+lA6b9pQKm/6UApgCmAKYApgCmAKYApv+lAqb+pQGmAKb/pQKm/qUBpgCmAKYApgCmAKb/pQOm/KUDpv+l/6UCpv+l/6UCpv6lAaYApv+lAqb+pQKm/lkAWgNa/FkEWvxZBFr8WQRa/VkBWgFa/VkEWv1ZAVoBWv1ZBFr8WQNa/lkBWv9ZAVr/WQJa/lkBWgBa/1kDWvxZBFr9WQJa/1kAWgBaAVr/WQBaAFoBWv5ZA1r9WQFaAVr+WQFaAFoAWgBaAFoAWgBaAKYApv+lA6b8pQSm/aUBpgGm/aUFpvqlBqb6pQam/KUBpgGm/aUEpv2lAaYBpv6lAqb+pQKm/6UBpv+lAKYBpv+lAab+pQKm/6UBpv+lAKYApgCmAab/pQCmAab+pQOm/aUCpv+lAab/pQGm/6UApgGm/6UBpgCm/qUCpv6lAqb/pQCmAKYApv+lAqb9pQOm/qUBpgCm/6UBpgCm/6UCpv2lA6b+pQGmAKb/pQGmAKb/pQGm/6UBpv+lAqb9pQOm/qUBpv+lAqb9pQSm/KUDpv6lAqb+pQKm/qUBpgCmAKYApgCm/6UBpgCm/6UCpv6lAaYApv+lAqb+pQKm/qUCpv2lA6b+pQGmAKb/pQGm/6UBpv+lAaYApv+lAab/pQGmAKb/pQKm/aUDpv6lAqb+pQKm/qUCpv+lAKYApgGm/qUDpv2lAqb/pQCmAab/pQGm/6UBpv+lAKYBpv+lAab/pQGm/qUDpv2lA6b+pQCmAab/pQGmAKb/pQGm/6UBpgCm/6UCpv2lA6b/pf+lAqb9pQOm/qUBpgCm/6UCpv6lAaYApgCmAKYBpv6lA6b9pQKm/6UApgGm/6UApgCmAKYApgFa/lkBWgBaAFoAWgFa/VkEWv1ZAVoBWv5ZAVoBWv5ZAVoAWv9ZAlr+WQFa/1kBWgBaAFr/WQFa/1kCWv5ZAVoAWv9ZAlr+WQFaAFr/WQJa/lkBWv9ZAVoAWv9ZAVr/WQFaAFr/WQFa/1kBWgBa/1kBWv+lAab/pQGm/6UBpv+lAab+pQOm/qUBpgCm/6UBpgCmAKYApgCm/6UCpv6lAqb+pQKm/qUBpgCmAKYApgGm/qUBpgGm/6UBpv+lAKYBpv+lAKYBpv+lAKYBpv6lAqb/pf+lA6b9pQGmAab9pQSm/aUCpv6lAqb+pQKm/6UApgCmAab+pQKm/qUCpv+lAKYApv+lAqb/pf+lAqb+pQKm/qUBpgCmAKYBpv2lBKb8pQOm/6X/pQKm/qUCpv6lAqb+pQKm/6UApgGm/qUCpv6lAqb/pQCmAKb/pQKm/aUFpvqlBab8pQOm/qUDpvylBKb8pQSm/aUCpv+lAKYApgCmAKYApgCmAKYApgCmAKYApgGm/qUCpv6lAaYBpv6lAqb+pQGmAKYApgCmAKYApgGm/qUCpv6lAqb/pQGm/qUCpv6lAqb/pQCmAab+pQKm/qUDpv2lAqb/pQCmAKYApgCmAab/pf+lAqb+pQOm/aUCpv6lAqb/pQGm/6X/pQKm/6UBpv+lAKYApgCmAab+pQOm/aUCpv+lAKYBpv+lAKYApgGm/6UBpv6lAaYBpv+lAab+pQKm/6UApgCmAKb/pQKm/aUDWv1ZA1r9WQJa/1kAWgJa/VkDWv1ZAloBWv1ZBFr8WQNa/1kAWgBaAFoAWgBaAFr/WQJa/lkBWv9ZAVoAWgBaAFr/WQJa/VkEWv1ZAVoAWv9ZAVoBWv5ZAVoAWv5ZBFr8WQJaAFr+WQNa/lkAWgFa/1kBpv+lAab/pQKm/aUDpv6lAaYApv+lAqb+pQKm/aUDpv6lAab/pQGm/6UBpv+lAKYBpv+lAqb+pQCmAaYApv+lAqb9pQOm/qUCpv2lA6b+pQGmAKb/pQGmAKb/pQGm/6UBpgCm/6UBpv+lAab/pQKm/aUCpgCm/qUDpv2lA6b+pQGm/qUDpv2lA6b+pQCmAqb9pQOm/aUEpvylA6b+pQCmAqb+pQGmAKb/pQGmAKb/pQKm/qUBpgCm/6UBpgCm/6UBpv+lAKYCpv2lA6b9pQKm/6UBpgCm/6UBpv+lAaYApv+lAKYBpgCm/6UApgCmAKYBpv6lAaYApv+lAqb+pQKm/aUEpvylBKb8pQOm/qUCpv+lAKb/pQGmAKYBpv6lAqb+pQKm/6UApgGm/qUDpv2lAaYBpv+lAKYBpv2lBKb+pQCmAqb8pQSm/qUBpv+lAab+pQOm/aUCpv+lAKYBpv6lAqb+pQKm/6UApgCm/6UCpv6lAaYApv+lAqb+pQGmAKYApgCm/6UCpv6lA6b8pQSm/KUEpv2lAaYBpv6lA6b8pQSm/KUFpvulBKb9pQKmAKb/pQCmAab/pQGm/6UApgGm/6UBWv5ZAloAWv5ZAlr/WQBaAVr+WQFaAVr+WQNa/FkEWvxZA1r+WQJa/lkCWv1ZA1r+WQJa/VkDWv5ZAVoAWgBaAFoAWv9ZAlr+WQJa/1n/WQNa/FkDWv9ZAFoAWgFa/VkEWvxZA1r/WQBa/1kCWv5ZAlr/pQCmAKYApgCmAKYApgCmAab9pQOm/aUDpv+l/6UBpv+lAqb9pQOm/aUDpv+lAKb/pQGm/6UCpv+lAKb/pQGmAKYApgGm/aUDpv6lAqb+pQKm/qUBpgCm/6UBpgCm/6UCpv2lAqYApv+lAqb+pQGmAKYApgCmAKYApv+lAqb+pQKm/qUBpgCmAKYApgCm/6UCpv+lAKYBpv2lBKb+pQCmAab/pQCmAaYApv6lA6b9pQGmAqb9pQOm/aUCpv+lAaYApv+lAab/pQGm/6UCpvylBab8pQKm/6UBpv+lAab/pQCmAab/pQGm/6UBpv6lA6b8pQSm/aUCpv+l/6UBpgCmAKYApgCm/6UCpv6lAaYBpv6lAaYBpv6lAqb/pQCmAKYBpv6lA6b9pQKm/qUDpv2lAqb+pQKm/6UBpv6lAqb+pQOm/aUDpv2lAqb/pQGm/6UBpv+lAab/pQCmAab+pQOm/aUBpgGm/qUCpv+lAKYApgGm/qUCpv6lAqb/pQCmAKYApgCmAKYApgCmAKYApgCmAKYApgGm/aUEpvylBKb+pf+lA6b8pQSm/aUCpgCm/6UBpv6lAqb/pQGm/6UApgCmAFoAWgFa/lkCWv9Z/1kDWvxZBFr9WQJa/1kBWv9ZAFoCWv1ZA1r+WQFaAFoAWv9ZAlr+WQFaAFoAWgBaAFr/WQFaAFoAWv9ZAVr/WQFaAFr/WQFa/1kAWgJa/VkDWv1ZA1r9WQNa/VkDWv5ZAFoCWv1ZA6b+pQCmAqb+pQGmAKb/pQGmAKYApgCmAKYApv+lAqb+pQKm/6X/pQGmAKb/pQGmAKb/pQKm/qUApgKm/qUDpv2lAqb+pQKm/qUDpvylBKb8pQSm/KUDpv6lAqb/pQCm/6UCpv6lA6b8pQSm/KUEpvylBKb9pQGmAKYApgCmAKb/pQKm/aUEpvulBab8pQKm/6UApgKm/aUCpv+lAKYBpv+lAKYApgGm/qUCpv6lAqb+pQKm/aUDpv+lAKYApv+lAaYApgGm/qUCpv6lAqb/pQCmAKYApgCmAKYBpv+lAKYApgCmAab/pQCmAKYBpv6lA6b8pQSm/KUDpv+lAKYBpv6lAqb/pf+lA6b9pQKm/6X/pQOm/KUFpvqlBab9pQKm/6UBpv6lAqb/pQCmAab+pQKm/qUBpgCm/6UCpv2lA6b9pQOm/qUBpgCm/6UBpgCm/6UCpv2lA6b9pQOm/qUApgGm/6UApgGm/qUDpv6lAKYBpv6lA6b9pQOm/qUApgKm/aUEpv2lAaYApv+lA6b8pQSm/KUDpv+l/6UCpv6lAaYApgCm/6UCpv6lAqb/pQCm/6UCpv6lA6b9pQGmAKYApv9ZAlr9WQRa/FkDWv1ZA1r9WQRa/FkDWv5ZAFoDWvxZA1r+WQBaAlr+WQFaAFr+WQNa/VkDWv5ZAVr/WQFa/1kBWgBa/1kBWv9ZAVr/WQJa/FkEWv1ZAlr/WQFa/lkCWv9ZAFoBWv5ZA1r9WQNa/VkBWgGm/6UBpv+lAKYBpv+lAKYBpv+lAab/pQCmAaYApv+lAKYBpv6lBKb8pQKm/6UBpv6lA6b+pQCmAab/pQGm/6UCpv2lA6b+pQCmAqb9pQOm/aUCpv+lAKYApgCmAKYBpv+lAKYApgGm/6UApgGm/qUDpv6l/6UCpv+lAKYApgCmAKYApgCm/6UBpgCmAKb/pQGm/6UCpv6lAab/pQKm/qUDpvylA6b/pQCmAKYApgCmAab+pQKm/qUBpgCmAKYApgCmAKb/pQKm/qUBpgGm/qUCpv+l/6UDpvylBab7pQSm/aUCpv6lAqb+pQOm/KUDpv6lAaYApgCm/6UCpv2lA6b9pQOm/qUBpv+lAKYBpgCm/6UBpv+lAKYBpgCm/6UCpvylBab7pQWm/KUCpgCm/qUDpv2lAqb/pQCmAab+pQKm/qUDpvylBKb8pQSm/aUBpgCmAKYApgCmAKYApgCmAKb/pQOm/KUDpv6lAaYApgCm/6UBpv+lAaYApv+lAqb+pQGmAKb/pQKm/6UApgCm/6UCpv6lAaYApgCm/6UCpv2lBKb9pQGmAKYBpv6lA6b8pQSm/aUBpgGm/qUCpv6lAaYAWgFa/lkDWvtZBVr+WQBaAVr+WQJa/1kBWv5ZAlr/WQBaAVr/Wf9ZA1r8WQRa/ln/WQNa/VkCWv9ZAFoBWgBa/lkCWv9ZAFoCWv1ZAlr/WQFa/1kBWv9ZAVoAWgBa/1kBWv9ZAlr+WQJa/VkDWv5ZAlr+pQGm/6UCpv2lBKb8pQOm/qUBpgCmAKYApv+lAqb+pQKm/qUBpgCmAKYApgCmAKb/pQOm+6UGpvqlBKb/pQCmAKYApv+lAqb/pf+lA6b8pQSm/aUCpv6lA6b9pQKmAKb9pQSm/aUCpv6lAab/pQGmAKb/pQGmAKb/pQGmAKb/pQOm+6UFpvylA6b+pQCmAaYApgCm/6UBpv+lA6b8pQOm/qUBpgGm/aUDpv6lAab/pQCmAKYBpv+lAKYBpv6lAqb/pQCmAqb9pQKm/6UApgGm/6UApgGm/qUDpv2lAqb/pQCmAKYBpv6lA6b8pQOm/qUBpgCm/6UBpgCm/6UBpv+lAab/pQKm/aUEpvylA6b+pQGmAKYBpv6lAqb9pQOm/qUCpv6lAaYApv+lAaYApv+lAqb+pQGmAKYApgCm/6UCpv2lBab6pQWm/KUDpv6lAqb+pQGm/6UBpgCmAKYApv+lAqb+pQGmAKYApgGm/qUCpv6lA6b9pQKm/6UApgGm/6UApgGm/qUCpgCm/qUDpvylBKb9pQOm/aUCpv+lAKYBpv6lA6b9pQKm/qUCpv6lA6b9pQKm/qUCpv6lAqb/pQCmAFr/WQJa/1kAWv9ZAVoAWgBaAFr/WQFaAFr/WQJa/VkEWvtZBlr5WQda+lkFWv1ZAVr/WQFaAFoAWgBaAFr/WQFaAFr/WQJa/lkAWgJa/VkDWv5ZAFoBWgBa/1kBWv9ZAFoBWv9ZAFoBWv9ZAFoBWv5ZA6b9pQOm/aUCpgCm/qUDpv2lAqYApv6lA6b+pQCmAab+pQOm/qUApgGm/6UApgGm/6UBpgCm/qUDpv6lAqb+pQGm/6UBpgCmAKb/pQKm/KUFpvylA6b+pQCmAab/pQKm/aUDpv6lAaYApv+lAqb+pQKm/qUBpgCmAKYApgCmAKYApgGm/qUCpv+lAKYBpv+lAKYBpv+lAKYCpvylBab6pQam/KUCpv+lAKYApgCmAab+pQOm/KUEpvylBKb9pQKm/6UApgCmAab/pQGm/6UBpv+lAab/pQGmAKb/pQGm/6UBpgCm/6UBpgCm/6UCpv2lAqYApv+lAab/pQCmAab/pQCmAKYBpv+lAKYApgCmAab/pQGm/6UApgGm/6UBpv+lAKYBpv+lAab+pQOm/aUCpv+lAKYBpv+lAab+pQOm/qUBpv+lAab/pQKm/qUCpv6lAqb/pQCmAKYApgCmAKYApgCmAKYApv+lAaYApgCmAab9pQSm/KUEpv2lAaYApv+lAqb9pQSm+6UFpvulBKb+pQGm/6UBpv+lAaYApv6lA6b9pQOm/qUApgGm/6UBpv+lAKYBpv+lAab/pQCmAKYBpv9ZAVr/WQFa/1kBWv9ZAVoAWv9ZAVoAWgBa/1kBWv9ZAlr/Wf9ZAlr+WQFaAVr9WQVa+lkGWvtZA1r/WQBaAFoBWv5ZAlr+WQFaAFoAWv9ZAVr/WQJa/VkDWv1ZA1r+WQFa/1kBWv9ZAVr/WQBaAVr/WQCmAab+pQKm/6UApgGm/6UApgGm/qUDpv6lAKYBpv+lAaYApv+lAqb9pQOm/qUApgGm/6UBpgCm/qUBpgCmAab/pQGm/qUCpv+lAab/pQGm/6UBpgCm/6UBpgCm/6UCpv6lAKYCpv2lA6b+pQGm/6UBpv+lAab/pQGm/6UBpv+lAab/pQGm/6UBpv+lAab/pQGmAKb/pQGmAKb/pQGmAKb/pQGmAKb/pQKm/aUDpv6lAaYApv+lAqb+pQKm/qUBpgCmAKYBpv6lAqb+pQKm/6UApgGm/qUBpgGm/qUDpvylA6b/pQCmAKb/pQKm/qUCpv6lAab/pQKm/qUBpgGm/aUEpv2lAaYApgGm/qUCpv6lAaYBpv6lAaYApv+lAqb+pQGmAKYApgCm/6UBpv+lAqb+pQCmAqb9pQOm/aUCpgCmAKYApv+lAab/pQKm/qUBpgCm/6UBpgCm/qUDpv2lA6b+pQGm/6UApgGm/6UBpgCm/6UBpv+lAKYCpv2lAqYApv6lBKb7pQSm/aUCpgCm/qUDpvylBKb9pQKm/6UBpv+lAKYApgGm/6UBpv6lAqb/pQCmAKYApgCmAKYApgCmAab/pQBaAVr+WQNa/VkDWv5ZAFoBWv5ZAlr/WQBaAVr/Wf9ZAlr+WQJa/1kAWgBaAFoAWgBaAVr9WQRa/FkEWv1ZAlr+WQJa/lkCWv9ZAFoBWv5ZAlr/WQBaAVr+WQJa/1kAWgFa/lkCWv9ZAFoBWv9ZAVr/WQGm/6UCpv2lBKb7pQWm/KUDpv6lAqb9pQOm/qUCpv+lAKb/pQKm/qUDpvylBKb9pQGmAab9pQSm/aUCpv6lAqb+pQKm/6X/pQKm/qUCpv6lAaYApgCmAKYApv+lAaYApgCmAKYApv+lAab/pQGmAKb/pQGm/qUDpv2lA6b9pQKm/6UBpv+lAab+pQOm/aUCpgCm/6UBpv+lAKYCpv6lAab/pQCmAab/pQGm/qUCpv+lAKYApgCmAKYBpv6lAqb+pQKm/6UApgGm/6UApgGm/6UBpv+lAab/pQGm/6UApgGm/6UApgCmAKYApgGm/qUCpv+l/6UDpvylBab7pQSm/aUDpv2lA6b9pQOm/aUDpv6lAab/pQGm/6UCpv6lAKYCpv2lBKb8pQKmAKYApgCm/6UCpv6lAqb+pQKm/qUCpv+lAKYBpv6lAqb+pQKm/6UApgGm/qUCpv6lA6b8pQWm+6UEpv2lAqb/pQCmAqb8pQSm/aUCpgCm/6UBpv+lAab/pQGmAKb/pQGm/6UApgGmAKb+pQSm+6UEpv6lAKYCpv2lA6b9pQOm/qUBpgCm/6UCpv6lAab/pQKm/qUCpv6lAKYCWv5ZAlr/Wf9ZAVoAWv9ZA1r7WQVa+1kEWv5ZAVr/WQFa/1kBWgBa/1kBWgBa/1kCWv1ZA1r+WQFaAFr+WQNa/lkBWv9ZAVr/WQFa/1kBWv9ZAVr+WQNa/VkDWvxZBFr9WQJa/1n/WQJa/1kAWgBaAFoApgCmAab9pQWm+qUGpvqlBqb6pQWm/aUBpgGm/qUBpgCmAKYApgGm/qUCpv6lAqb+pQKm/6X/pQKm/qUBpgCmAKb/pQGm/6UBpgCm/6UApgCmAab/pQGm/qUCpv+lAKYBpv+lAKYBpv6lAqb/pQCmAKYApgCmAKYApgCm/6UDpvylBab6pQWm/KUEpv2lAqb+pQGmAab+pQKm/qUCpv+lAKYApgCmAKYApgCm/6UCpv6lAaYApv+lAaYApv+lAab/pQGm/6UCpv2lA6b+pQCmAaYApv+lAqb9pQOm/qUBpgCm/6UCpv6lAaYApv+lAqb+pQGm/6UBpv+lAqb9pQOm/aUCpgCm/qUDpvylBKb9pQGmAKb/pQKm/qUBpgCm/6UBpgCmAKYApgCm/6UBpgCmAKYApgCm/6UBpv+lAqb+pQGmAKb/pQKm/aUDpv6lAaYApv6lBKb8pQOm/aUCpgCm/6UBpv6lAqb/pQCmAKYApgCmAKYApv+lAqb+pQKm/qUCpv6lAaYApgCmAKYApv+lAqb+pQKm/aUDpv+lAKYApgCm/6UDpv2lAaYApgCmAab+pQGmAKYApgCmAKb/pQKm/1kAWgBa/1kCWv5ZAlr/Wf9ZAVoAWv9ZAlr+WQBaAVr/WQFa/1kAWgBaAFoAWgFa/VkEWvxZBFr9WQJa/lkCWv9ZAVr+WQJa/lkDWv1ZAlr/WQBaAVr/WQFa/1kBWv9ZAVr/WQBaAFoBWv5ZA1r8WQNa/6X/pQOm/KUDpv6lAqb+pQKm/qUBpgCmAKYApgCmAKYApgCmAKYApgCmAKYApgGm/qUBpgCm/6UDpvylA6b+pQGmAKb/pQGmAKb/pQKm/aUDpv2lA6b+pQGm/6UCpvylBqb6pQSm/qUBpv+lAqb9pQKmAKYApv+lAqb9pQOm/qUBpgCm/6UCpv2lA6b+pQGmAKb/pQKm/qUDpvylA6b/pQCmAab+pQGmAab+pQKm/qUBpgCmAKYApv+lAab/pQGmAKb/pQGm/qUDpv2lA6b9pQKm/6UApgGm/6UApgGm/qUDpv2lAqYApv+lAab+pQOm/aUDpv2lAqYApv+lAKYBpv+lAqb+pQCmAaYApgCmAKb/pQCmAqb+pQGmAKb+pQOm/aUDpv2lA6b9pQKm/6UBpgCm/6UBpv6lBKb7pQWm+6UFpvylAqYApv6lBKb8pQKmAKb/pQKm/aUDpv2lA6b+pQGm/6UApgGm/6UBpv+lAab/pQGm/qUDpv6lAab/pQGmAKb/pQGmAKb/pQKm/qUApgGm/6UBpgCmAKb+pQKm/6UBpgCm/6UApgCmAab+pQKm/6UApgGm/qUCpv6lA6b9pQJa/1kAWgFa/lkCWv5ZAlr/WQFa/VkFWvpZB1r5WQZa+1kEWv5ZAFoBWv9ZAFoBWv9ZAVr/WQBaAVr/WQFa/1kBWv9ZAVr/WQFaAFr/WQJa/lkBWgBaAFr/WQJa/lkCWv9Z/1kCWv5ZAlr+WQFaAFoAWgCm/qUDpv2lAqYApv6lAqb/pQCmAab/pQCmAKYBpgCm/6UBpv+lAab/pQKm/aUDpv6lAaYApv+lAab/pQGmAKb/pQKm/aUDpv6lAaYApv+lAqb+pQGm/6UBpv+lAaYApv6lA6b9pQKm/6UApgGm/6UApgGm/aUFpvqlBqb7pQOm/6X/pQOm/KUEpvylBab7pQSm/aUCpv+lAab+pQKm/6UApgGm/qUBpgGm/qUCpv+l/6UCpv+lAKYBpv6lAqb/pQCmAKYApv+lAqb+pQGmAKb/pQKm/aUDpv2lA6b+pQGm/6UBpv+lAab/pQGm/6UBpv+lAab/pQCmAqb9pQKmAKb+pQSm/KUDpv6lAaYApv+lAqb+pQGmAKb/pQGmAKb/pQKm/qUBpv+lAaYApgCmAKb/pQGmAKb/pQKm/qUBpv+lAqb9pQOm/aUCpgCm/6UBpv+lAab/pQGm/6UBpgCm/6UBpgCm/6UBpv+lAaYApv+lAab/pQGmAKb/pQGm/6UCpv2lA6b9pQOm/qUApgGm/6UBpv+lAKYApgGm/6UBpv6lAaYApgGm/qUCpv2lA6b+pQGmAKb/pQKm/aUEpvylA6b+WQFaAFr/WQJa/VkEWvtZBFr+WQFaAVr+WQBaAVr/WQJa/lkBWv9ZAFoBWv9ZAlr9WQJa/1kBWv9ZAVr+WQNa/VkCWv9Z/1kEWvtZBFr9WQFaAlr9WQJa/1kBWv9ZAVr+WQNa/lkBWv9ZAVr/WQFa/1kBpv+lAab/pQGm/6UBpv+lAab/pQGmAKYApv+lAKYBpgCm/6UCpv2lA6b9pQKm/6UBpv+lAab+pQOm/aUCpv+lAKYBpv+lAab/pQGm/6UBpv+lAaYApgCm/6UBpv+lAab/pQGmAKb/pQGm/6UApgKm/aUDpv6lAKYBpv6lA6b9pQOm/aUBpgKm/KUFpvulBKb+pQGm/6UApgGm/6UBpv+lAKYApgCmAKYBpv6lAqb+pQGmAab+pQKm/qUCpv+lAKYApgCmAKYBpv6lAqb+pQGmAKYApgCmAKb/pQGmAKYApgCmAKYApgCm/6UCpv6lAqb+pQGmAKYApv+lAqb+pQKm/qUCpv6lAqb9pQSm+6UGpvqlBKb9pQOm/aUDpv6lAab/pQGm/6UCpv2lA6b9pQKmAab9pQKm/6UApgGm/6UBpv+lAab/pQCmAab/pQKm/aUDpv2lAqYApv+lAab/pQCmAab/pQGm/6UApgGm/qUDpv2lAqb/pQCmAqb9pQOm/aUCpgCm/6UBpgCm/6UBpv+lAKYCpv6lAab/pQCmAaYApgCm/6UBpv6lBKb7pQSm/qUApgGm/6UApgCmAab+pQKm/6UAWgBaAVr+WQJa/lkCWv5ZAlr/WQBaAFr/WQJa/lkCWv5ZAVoAWgBa/1kBWgBa/1kDWvtZBVr8WQNa/lkBWv9ZAVoAWv9ZAVr/WQFa/1kBWgBa/1kBWgBa/1kCWv1ZA1r+WQFaAFr/WQJa/lkCWv5ZAlr+pQGmAab+pQKm/6X+pQSm/KUDpv6lAaYApv+lAqb+pQGmAKb/pQOm/KUDpv+l/6UCpv6lAaYApgCm/6UCpv6lAab/pQKm/qUBpgCm/qUFpvmlB6b7pQOm/6X/pQKm/qUCpv6lAaYBpv2lBKb8pQKmAab+pQKm/6X/pQOm/KUEpv6lAKYBpv6lA6b9pQOm/aUCpv+lAab/pQCmAab/pQGmAKb+pQOm/aUDpv2lAqYApv6lA6b9pQGmAqb8pQSm/aUCpv+lAab/pQCmAab/pQGmAKb/pQGmAKb/pQGmAKb+pQOm/aUCpgCm/qUCpv+lAKYApgGm/qUCpv+lAKYBpv+lAKYBpv+lAab/pQGm/qUDpv2lA6b9pQGmAKYApgGm/qUCpv6lAaYApgCm/6UCpv6lAqb+pQGm/6UCpv6lAqb9pQOm/qUCpv6lAqb+pQGmAab+pQKm/6X/pQKm/qUBpgCmAKYApgCm/6UCpv6lA6b8pQOm/6UApgCmAKYApv+lA6b8pQOm/6X/pQGmAKYApgCmAKb/pQKm/aUDpv6lAaYApv+lAKYCpv6lAaYApv+lAaYApv+lAqb+pQGm/6UApgGm/1kBWv9ZAFoBWv5ZA1r9WQJa/1kAWgFaAFr+WQNa/VkCWgBa/lkDWv1ZA1r8WQVa+1kEWv5ZAFoBWv9ZAVoAWv9ZAVr/WQJa/lkBWgBa/1kCWv5ZAVoAWv9ZAlr+WQJa/lkAWgJa/lkCWv5ZAVr/WQJa/qUCpv2lBKb8pQOm/qUApgGmAKb/pQGm/6UApgGm/6UBpv+lAKYBpv6lA6b8pQWm+qUGpvqlBqb8pQKm/qUBpgCmAab/pQGm/aUEpv2lAqb/pQCmAab/pQGm/qUDpv6lAaYApv+lAqb+pQGmAab+pQKm/qUCpv6lAaYApgCmAab+pQKm/qUCpv+lAKYBpv6lA6b8pQSm/aUBpgGm/qUBpgCm/6UCpv6lAab/pQGmAKb/pQKm/aUDpv2lA6b+pQGm/6UApgGm/6UBpv+lAab/pQGm/6UBpv+lAab/pQKm/aUDpv6lAaYApgCmAKYApgGm/qUCpv+lAKYApgCmAKYBpv+l/6UBpgCmAab/pf+lAqb+pQKm/6X/pQKm/qUCpv6lAqb+pQGmAab9pQSm/KUDpv+lAKYApgCmAKYApgCmAab/pQGm/6UApgGm/6UBpv+lAab+pQOm/KUEpv2lAaYBpv6lAqb+pQGmAab+pQKm/qUBpgGm/aUDpv6lAaYApv+lAab/pQKm/aUCpv+lAab/pQKm/KUEpv6lAKYCpv2lAqb/pQGm/6UBpv+lAKYBpv+lAab/pQGm/6UBpgCm/6UBpv9ZAVr/WQJa/VkDWv5ZAFoBWgBa/lkDWv5ZAFoBWv9ZAVr/WQFa/1kAWgFa/1kAWgFa/lkCWv9ZAFoBWv5ZAlr/WQFa/lkCWv9ZAVr/WQBaAVr/WQJa/VkCWgBa/1kBWv9ZAFoCWvxZBVr6WQZa/FkCWv+lAKYApgGm/6UApgGm/qUDpv2lAqb+pQOm/aUDpv2lAqb/pQGm/6UBpv+lAKYBpv6lA6b9pQKm/6X/pQOm/aUCpv6lA6b8pQWm+6UEpvylBab8pQOm/aUBpgCmAqb9pQOm/KUEpv2lAqYApv+lAab/pQGm/6UCpv2lA6b+pQGm/6UBpv+lAqb9pQKm/6UBpgCm/qUDpvylBab8pQKm/6UApgCmAab/pQGm/qUCpv6lAqYApv6lAqb+pQOm/KUFpvulA6YApv6lAqYApv6lA6b9pQKmAKb/pQGmAKb+pQOm/aUCpgCm/6UApgGm/6UBpv+lAab/pQKm/qUBpgCm/6UCpv6lAqb+pQGmAKYApgCmAKb/pQKm/qUCpv6lAaYBpv6lAqb/pQCmAab+pQKm/6UApgGm/qUCpv+l/6UDpvylBKb9pQGmAab+pQOm/KUEpv2lAqYApv6lAqb/pQCmAab/pQGm/6UBpv+lAKYCpv2lAqYApv+lAKYBpv6lA6b9pQOm/KUFpvulBab7pQSm/aUCpgCm/qUDpv2lA6b+pQCmAqb9pQOm/qUBpv+lAab/pQGm/6UApgGm/6UApgGm/qUCWv9ZAFoAWgBaAFoAWgFa/lkCWv5ZAlr/WQBaAFoAWgFa/1kAWgBaAFoBWv9ZAVr+WQJa/1kAWgFa/lkCWv5ZAlr+WQJa/lkBWgBaAFoAWgBa/1kCWv5ZAlr/Wf9ZA1r8WQRa/VkCWv5ZAlr/WQBaAVr+pQKm/6UApgCmAKYApgCm/6UCpv2lBKb8pQOm/aUDpv6lAaYBpv2lA6b+pQGmAKYBpv6lAqb+pQKm/qUDpv2lAqb/pf+lAqb/pQGm/qUDpvylBKb9pQKm/6UApgCmAKYApgCm/6UCpv6lAaYApv+lAqb+pQGmAKb/pQKm/qUBpgCm/qUDpv6lAaYApv6lA6b9pQOm/aUCpv+lAab/pQCmAab+pQKm/6UBpgCm/qUCpv+lAqb9pQOm/aUDpv6lAKYBpgCm/qUCpv+lAKYCpv2lAaYBpv6lAqYApv6lA6b9pQKm/6UBpgCm/6UApgGm/qUEpvulBKb8pQWm+qUGpvulBKb9pQKm/qUDpv2lAqb/pQGm/6UBpv6lA6b9pQOm/qUApgGm/qUDpv2lA6b+pQCmAab/pQGm/6UBpv6lA6b9pQKm/qUCpv+lAKYBpv6lAqb/pQCmAab/pQCmAab+pQOm/aUCpv+lAab/pQGm/6UBpgCmAKb/pQKm/aUEpvylA6b+pQGmAKb/pQGmAKb/pQKm/aUDpv6lAaYApv+lAqb+pQGmAKb/pQKm/6X/pQKm/aUDpv6lAqb+pQGmAKb/pQKm/lkCWv1ZBFr9WQFaAFoAWv9ZA1r7WQVa/FkDWv5ZAVr/WQFa/1kBWgBa/1kBWv9ZAVr/WQFa/1kBWgBa/1kBWv9ZAVoAWv9ZAVr/WQFa/1kBWv9ZAVr/WQFaAFr/WQFa/1kBWgBa/1kBWv9ZAlr9WQNa/aUDpv6lAKYApgGm/6UBpv+l/6UCpv+lAKYApgGm/aUFpvqlBab9pQKm/6UApv+lA6b8pQSm/KUDpv+l/6UBpv+lAaYApgCm/6UBpv+lAab/pQGm/6UCpv6lAaYApv+lA6b8pQSm/aUCpv+lAKYApgGm/qUCpv+lAKYBpv6lAqb/pQCmAab+pQKm/6UApgGm/qUDpv2lAqb/pQCmAqb9pQOm/aUCpgCm/6UBpv+lAab/pQKm/KUFpvulBab8pQKmAKb+pQOm/aUCpgCm/6UApgGm/6UBpv+lAKYApgGm/qUCpv6lAqb+pQKm/qUCpv+lAab/pQCmAab+pQSm+6UEpv2lAqb/pQGm/6UApgGm/qUDpv6lAKYBpv+lAKYCpv2lA6b9pQKm/6UBpgCm/6UApgCmAKYBpgCm/qUCpv6lAqb/pQGm/qUCpv+l/6UDpvylBKb9pQCmA6b8pQSm/aUBpgGm/qUDpvylBKb9pQKm/6UBpv6lA6b8pQSm/aUCpv6lAqb+pQKm/aUEpvylA6b/pQCm/6UCpv6lAqb/pf+lAqb9pQSm/KUDpv6lAab/pQKm/qUBpgCmAKb/pQOm/KUDpv+l/1kCWv5ZAVoAWgBaAFr/WQJa/lkCWv9ZAFoAWgFa/lkDWv1ZAlr/WQFa/lkDWv1ZA1r9WQNa/VkDWv5ZAFoCWv5ZAVoAWv5ZBFr8WQRa/FkDWv5ZAVoAWgBaAFr/WQFa/1kBWgBa/1kBWv9ZAFoCWv1ZBKb7pQWm/KUCpgCm/qUEpvylAqb/pQCmAab/pQGm/6UApgCmAKYBpv+lAKYApgCmAKYApgCmAab+pQGmAKYApgCmAKb/pQKm/qUBpgCm/6UCpv2lA6b+pQGmAKb/pQGmAKb/pQKm/qUCpv6lAaYApgCmAKYBpv2lBKb9pQGmAKYApgCmAKYApgCmAKYBpv6lAqb/pQCmAab/pQGm/qUCpv+lAKYBpv6lAqb/pQGm/qUDpvylBab8pQOm/qUBpv+lAaYApv+lAqb9pQOm/aUDpv6lAaYApv+lAab/pQKm/qUBpgCm/6UCpv+l/6UCpv6lAqb+pQKm/qUCpv6lAaYApgCmAKb/pQKm/aUDpv6lAaYBpv2lA6b9pQSm/aUBpgCm/6UBpgCm/6UCpv6lAKYBpv6lA6b9pQKm/6UApgCmAKYBpv+lAab+pQOm/aUDpv2lAqb/pQGm/6UApgCmAKYBpv+lAKYBpv6lA6b9pQKmAKb/pQGm/6UBpv+lAab/pQGmAKb/pQCmAaYApv+lAab+pQKmAKb/pQGm/qUCpv6lA6b+pQCmAab+pQKmAKb/pQGm/6UApgGmAKb/pQGm/6UBpv9ZAlr9WQNa/lkBWgBaAFr/WQJa/VkEWvxZA1r+WQBaAlr+WQJa/lkBWv9ZAlr/WQBaAFr/WQFaAFr/WQFaAFr/WQFa/1kAWgJa/lkAWgFa/1kBWgBa/1kBWv9ZAFoBWv9ZAlr9WQJa/1kAWgJa/VkDWv6lAKYBpv+lAaYApv+lAKYApgGm/6UBpv+lAKYApgGm/qUDpv2lAqb/pQCmAab/pQGm/qUDpv2lAqYApv6lA6b9pQGmAab/pQCmAab+pQKm/6UApgCmAab+pQOm/KUEpvylBKb9pQGmAKYApgCmAab+pQKm/qUCpv+lAKYBpv6lA6b8pQSm/KUEpv2lAqb+pQKm/qUCpv6lAaYBpv6lAqb/pf+lAqb/pf+lA6b9pQKm/qUBpgCmAab+pQKm/qUCpv+lAKYBpv+lAab/pQGm/6UBpgCm/6UCpv2lA6b+pQKm/qUBpgCmAKYApgCm/6UCpv+l/6UDpvulBab8pQOm/6UApv+lAab/pQKm/qUCpv6lAaYApv+lAqb+pQGmAKb/pQKm/aUDpv2lA6b+pQCmAqb8pQSm/qUApgGm/6UApgGm/6UApgGm/qUCpv+lAKYBpv6lAqb+pQKm/6UApgGm/qUCpv6lAqb/pQGm/qUCpv6lAqb/pQCmAKYBpv6lAqb+pQKm/6UApgGm/qUCpv+lAKYCpv2lA6b8pQWm/KUCpgCm/6UBpgCm/6UBpgGm/aUEpvylA6b+pQKm/qUCpv6lAaYAWgBaAFoAWgBaAFoAWv9ZAlr9WQRa/VkBWv9ZAVoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBa/1kCWv5ZAVoAWv9ZAlr+WQFaAFoAWgBaAFr/WQFaAVr+WQFa/1kBWgBaAFoAWv9ZAlr+WQJa/lkCpv+lAab/pQCmAab/pQGm/6UCpv2lA6b8pQWm/KUCpgCm/qUDpv2lAqYApv+lAqb9pQOm/qUBpgCmAKYApgCm/6UCpv6lAqb+pQKm/6UApgCmAKYApgGm/6UApgCmAab9pQWm+6UEpv2lAqb/pQGm/6UApgCmAab+pQOm/KUEpv2lAaYApv+lAqb/pf+lAab/pQGmAKYApv+lAaYApv+lAqb/pf+lAqb+pQGmAKYApv+lAqb9pQOm/qUCpv6lAqb+pQKm/qUCpv6lAqb+pQKm/qUBpgCmAKb/pQKm/aUEpv2lAKYCpv2lA6b+pQGm/6UBpgCm/6UBpv6lA6b+pQGm/6UApgGm/6UBpv+lAKYBpv+lAaYApv6lA6b+pQGmAKb/pQKm/qUBpv+lAqb+pQKm/aUDpv6lAqb+pQKm/qUCpv2lBKb9pQKm/6X/pQKm/qUCpv6lAqb+pQKm/qUBpgCmAKYBpv6lAaYBpv6lAqb+pQKm/qUCpv2lA6b+pQGmAKb/pQGmAKYApv+lAqb+pQKm/qUCpv6lAqb/pf+lAqb/pQCmAab+pQKm/6UBpv6lA6b8pQWm+6UDpgCm/qUDpvylBFr9WQJa/1n/WQJa/1kAWgBaAFoAWgBaAFoAWgFa/lkDWvxZBFr9WQJa/1kBWv9ZAFoAWgBaAFoBWv5ZAlr/WQBaAFoAWgBaAFoBWv5ZAlr+WQFaAVr+WQJa/1kAWgFa/lkCWv9ZAFoCWvxZBFr9WQFaAab/pQCmAKYBpv6lA6b8pQOm/6UApgCmAKb/pQKm/aUDpv2lA6b+pQGm/6UBpv+lAaYApv+lAqb9pQOm/qUCpv6lAab/pQKm/aUEpvulBab8pQOm/aUCpv+lAab/pQGm/aUFpvqlBqb7pQSm/aUCpv6lA6b9pQKm/6UApgGm/qUCpv+lAKYApv+lAqb+pQOm/KUDpv6lAqb+pQKm/qUCpv+lAKYApgCmAab+pQOm/KUEpv2lAqb/pQCmAKYBpv6lA6b9pQKm/6UApgKm/aUDpvylBab7pQWm/KUCpgCm/6UBpgCm/6UCpv6lAaYApv+lAqb+pQGm/6UBpv+lAqb9pQOm/aUCpv+lAKYBpv6lAqb/pf+lA6b8pQOm/6X/pQOm/KUEpvylA6b+pQGmAKYApgCm/6UBpv+lAaYApgCm/6UCpv2lA6b+pQKm/qUBpgCmAKYApgCm/6UBpgCm/6UCpv2lA6b+pQCmAqb+pQKm/qUBpv+lAqb+pQKm/qUBpv+lAaYApgCm/6UBpv+lAab/pQCmAab/pQCmAab+pQKm/qUCpv+lAKYApgCmAab+pQKm/qUCpv+lAKYApgGm/qUDpvxZBFr9WQJa/1kBWv9ZAFoBWv5ZA1r+WQBaAlr8WQVa/FkCWgBa/lkDWv1ZAloAWv5ZA1r9WQJa/1kBWv9ZAlr9WQJa/1kBWv9ZAFoBWv5ZAlr+WQJa/lkBWgBaAFoBWv5ZAlr9WQRa/VkCWgBa/lkDWvylBKb+pQCmAab+pQGmAab+pQKm/qUBpgCmAKYApgCmAKYApgCm/6UBpv+lAqb+pQGm/6UApgGmAKb/pQGm/6UApgKm/qUApgGm/qUDpv2lAqb+pQKm/6UApgCmAKYApgCmAab+pQKm/6UApgGm/qUCpv+lAKYApgCmAKYApgCmAKb/pQGmAKb/pQGm/6UBpv+lAqb8pQWm+6UEpv2lA6b9pQOm/KUEpv2lA6b+pQCmAKYApgGm/6UApgCmAKYApgCmAKYApgCmAKYApgCmAKYApgGm/6UApgCmAKYBpv+lAKYApgGm/qUCpv2lA6b/pQCmAKb/pQGmAKYApv+lAab/pQKm/aUDpv6lAab/pQGmAKb/pQKm/aUDpv2lBKb7pQWm+6UFpvylA6b+pQGmAKYApgCmAKYApgCmAKYApgGm/qUCpv6lAaYApgCm/6UCpv6lAaYApv+lAaYApgCmAKYApv+lAqb+pQKm/qUCpv6lAqb/pf+lAqb+pQKmAKb9pQSm/KUDpv6lAqb/pQCmAKb/pQKm/6UBpv6lA6b9pQKm/6UBpv+lAab+pQKm/6UApgGm/qUCpv6lAqb/pQCmAab9WQVa+1kDWv9Z/1kCWv5ZAVoAWgBa/1kCWv5ZAVoAWgBa/1kCWv5ZAVoAWv9ZAVoAWgBa/1kCWv5ZAVoAWv9ZAVoAWv9ZAlr9WQNa/VkDWv1ZA1r9WQJaAFr+WQNa/VkCWv9ZAVr+WQNa/VkCWv9ZAFoAWgGm/qUCpv6lAqb/pQCmAKYApgCmAKYApgCmAKb/pQGmAKYApv+lAab/pQKm/6UApgCmAKYApgGm/qUCpv+lAKYApgGm/qUCpv6lAaYBpv+lAKYApgCmAab/pQCmAab+pQSm/KUCpv+lAKYBpv+lAab/pQCmAKYApgGm/6UBpv+lAKYCpv2lBKb7pQSm/aUEpvylAqb/pQCmAqb+pQGmAKb/pQGmAKb/pQKm/qUBpgCm/qUEpvylA6b+pQCmAaYApv6lA6b9pQKm/6UApgCmAab/pQCmAKYApgGm/6UBpv6lA6b9pQKmAKb+pQSm+6UFpvylAqb/pQGmAKb/pQCmAab+pQOm/aUCpgCm/qUDpvylBab7pQSm/aUCpv+lAKYApgCmAab+pQKm/qUCpv+lAKYApgGm/qUCpv+l/6UCpv6lAaYBpv2lA6b9pQOm/qUBpgCm/6UBpgCm/6UCpv2lAqb/pQKm/aUDpv2lA6b+pQKm/aUDpv6lAaYBpv6lAaYApv+lAqb/pQCmAKb/pQKm/qUCpv6lAaYApgCmAKb/pQKm/qUCpv+l/6UCpv6lAqb+pQGm/6UBpgCmAKb/pQKm/aUEWvxZBFr9WQFaAFr/WQJa/VkEWvtZBlr6WQRa/lkBWgBaAFoAWgBa/1kCWv5ZA1r8WQRa/FkEWv1ZAlr/WQBaAVr9WQRa/VkBWgFa/VkEWv1ZAVoBWv5ZAlr+WQJa/1kAWgBa/1kCWv5ZAlr+WQFa/1kBpgCm/6UBpv+lAab/pQGm/qUCpgCm/6UBpv6lAqb/pQKm/qUBpv+lAaYApgCmAab9pQOm/qUBpgCm/6UBpgCm/6UBpv+lAaYApv+lAqb9pQKmAKb/pQGm/6UApgGm/6UBpv6lA6b+pQGm/qUCpv+lAqb+pQCmAab/pQKm/qUBpgCmAKYApgGm/qUCpv6lAqb/pQCmAKYApv+lA6b7pQWm/KUCpgGm/aUDpv2lA6b/pQCmAKb/pQGmAab+pQKm/qUCpv6lAqb9pQSm/aUCpv6lAqb/pQCmAab+pQOm/aUCpv+lAKYBpv6lAqb+pQOm/aUBpgCm/6UCpv+l/6UBpgCm/qUEpvulBab8pQKmAKb+pQOm/aUCpv+lAKYBpv6lA6b9pQOm/aUCpv+lAaYApv+lAKYApgCmAab/pQGm/6UApgGm/6UCpv6lAaYApv+lAqb+pQKm/aUEpvulBab8pQKm/6UBpv+lAKYBpv6lA6b9pQKm/6UApgGm/6UApgCmAKYApgCmAab+pQOm/KUDpgCm/6UBpv+lAab/pQKm/aUDpv6lAKYCpv2lA6b9pQKm/6UBpv+lAab/pQGmAKb/pQGmAFoAWv9ZA1r7WQVa/VkBWgFa/VkDWv5ZAlr+WQJa/VkEWvxZA1r/Wf9ZAlr+WQFaAFoAWv9ZAlr+WQFaAVr+WQJa/lkBWgFa/1kAWgBaAFoAWgFa/lkCWv9ZAFoAWgBaAFoBWv5ZA1r8WQNa/lkBWgFa/6X/pQGmAKYApgCmAKYApgCm/6UBpgCmAab+pQGm/6UBpgGm/qUBpgCmAKYApgCm/6UCpv6lA6b8pQOm/qUCpv+lAab+pQKm/6UBpv+lAab/pQCmAab/pQCmAab+pQKm/6UApgCmAKYBpv6lA6b8pQSm/aUCpv6lAqb/pQCmAab9pQSm/aUCpv+lAKYBpv+lAab+pQOm/aUDpv6lAKYBpv+lAaYApv+lAqb+pQGmAab+pQKm/qUCpv+lAab+pQKm/qUDpv2lAqb/pQCmAab+pQKm/6UApgGm/aUDpv+l/6UCpv6lAaYApgCmAKYApgCm/6UCpv6lAaYApv+lAaYApv+lAKYCpv2lA6b9pQGmAab/pQCmAab+pQOm/KUEpvylBKb9pQGmAab9pQSm/KUDpv+l/6UCpv6lAqb/pQCm/6UCpv6lAqb+pQGmAKb/pQOm+6UFpvylA6b/pf+lAqb9pQOm/qUBpgCm/6UApgGm/6UCpv2lAqb/pQGm/6UBpv6lA6b+pQCmAqb8pQWm/KUCpgCmAKb/pQKm/KUFpvylA6b+pQCmAab/pQKm/qUBpv+lAaYApgCmAKb/pQGm/6UBpv9ZAlr+WQBaAlr8WQVa/VkAWgJa/VkDWv5ZAVr/WQFaAFr/WQJa/VkEWvtZBVr8WQNa/lkBWgBa/1kCWv1ZA1r+WQFaAFr/WQFaAFoAWv9ZAVr/WQJa/1kAWgBa/1kCWv9ZAVr+WQFaAVr+WQNa/FkDWgCm/aUEpvylBKb9pQKm/qUBpgCmAab+pQKm/qUBpgGm/6X/pQKm/qUCpv+l/6UCpv6lA6b9pQGmAKYBpv+lAab+pQKm/6UApgGm/aUFpvulBKb9pQGmAab+pQKm/qUCpv6lAqb9pQOm/qUCpv6lAaYApgCmAKYApgCmAab+pQKm/6UApgKm/aUCpv+lAab/pQGm/6UBpv+lAab/pQGm/6UBpv+lAaYApv+lAab/pQGmAKb/pQGm/qUDpv2lA6b8pQOm/6X/pQOm/KUDpv+l/6UCpv+lAKYBpv6lAqb/pQCmAab/pQCmAqb8pQWm+6UEpv2lAqb+pQKm/qUBpgCm/6UCpv6lAaYApgCmAKYBpv6lAqb+pQKm/6UApgGm/qUCpv+lAab/pQGm/qUDpv2lA6b9pQKm/qUCpv+lAKYBpv6lAqb/pQCmAKYBpv6lA6b9pQKm/6UApgGmAKb/pQGm/6UBpgCmAKb/pQGmAKb/pQKm/aUCpgCm/6UBpv+lAKYBpv+lAab/pQCmAab/pQGm/6UApgCmAab/pQCmAab+pQOm/aUCpv+lAKYBpv+lAab+pQOm/aUCpgCm/qUCpv+lAab+WQJa/lkCWv9Z/1kBWgBaAFoAWgBa/1kBWgFa/VkEWvxZAloBWv5ZAlr9WQNa/lkCWv5ZAVoAWgBa/1kCWv5ZAVoAWv9ZAlr/Wf5ZBFr7WQZa+1kCWgBa/1kBWv9ZAVoAWgBa/lkDWv1ZA1r+WQFa/1kCpvylBKb+pQCmAab+pQOm/aUCpv6lAqb/pQGm/qUCpv+lAKYBpv6lA6b9pQKmAKb+pQSm/KUDpv6lAaYApgCm/6UCpv6lAqb+pQGmAKYApgCmAKb/pQGmAKb/pQKm/qUBpgCmAKYApgGm/qUCpv6lAqb/pQCmAKYApgCmAKYApgCmAKYApv+lAqb+pQGmAKb/pQKm/qUBpgCmAKYApgCmAKb/pQOm/KUEpvylAqYBpv6lAqb+pQKm/qUCpv6lAaYBpv6lAqb+pQKm/qUCpv6lAqb/pQCmAKYApgCmAKYApgCmAKYBpv2lA6b+pQGmAab+pQGmAKb/pQKm/qUCpv6lAaYApgCmAab9pQSm/KUEpvylA6b/pQCmAab+pQGmAab+pQKm/6UApgCmAab+pQOm/KUFpvulBab7pQSm/aUDpv6lAab/pQGm/6UCpv6lAqb+pQGm/6UBpgCm/6UCpvylBab8pQKmAKb+pQOm/aUCpv+lAKYApgGm/qUCpv6lAqb+pQKm/qUCpv6lAqb+pQKm/qUCpv6lAqb+pQKm/qUCpv+lAKYApgCmAKYBpv+l/6UDpv2lAqYApv6lA6b9pQOm/VkDWv5ZAFoCWv1ZA1r9WQNa/VkEWvtZBFr+WQBaAlr9WQNa/VkCWv9ZAVr/WQFa/1kAWgJa/FkFWvtZBFr+WQFa/1kBWv5ZA1r+WQFa/1kAWgFa/1kBWv9ZAVr/WQFa/1kBWv9ZAVoAWv9ZAVr+WQNa/qUCpv2lA6b9pQOm/qUBpgCm/6UBpv+lAaYApv+lAab/pQGm/6UBpv6lAqb/pQGm/qUCpv6lAqb+pQKm/qUBpgCm/6UCpv6lAKYCpv6lAqb+pQKm/qUCpv+lAKYBpv6lAqb/pQCmAab+pQKm/qUCpv+lAKYBpv6lA6b9pQKm/6UBpv+lAab/pQGm/6UBpv+lAaYApv+lAab/pQKm/aUDpv2lA6b+pQCmAab+pQOm/aUCpv+lAKYBpv6lAqb/pQGm/6UApgCmAab/pQGm/qUCpv+lAKYBpv6lAqb/pQCmAKYBpv6lA6b8pQSm/aUCpv6lAaYApgCm/6UCpv2lA6b9pQKm/6UBpv+lAab/pQCmAab/pQGm/6UBpv+lAqb9pQKm/6UApgKm/aUDpv2lAqb+pQOm/qUBpgCm/qUDpv6lAaYApv+lAqb+pQKm/qUBpgCmAKYApgCmAKb/pQKm/qUCpv+l/6UCpv6lAqb+pQKm/qUCpv6lAqb+pQKm/qUCpv+lAKYApgCmAKYApgCm/6UCpv2lBKb8pQSm/KUDpv+lAKYBpv6lAqb/pQGm/qUCpv+lAKYApgCmAKYBpv+l/6UCpv6lA1r9WQFaAVr9WQVa+1kDWv9ZAFoAWgBaAFoBWv9ZAFoBWv5ZAloAWv5ZA1r9WQJaAFr+WQNa/VkDWv1ZA1r9WQNa/VkCWv9ZAVr/WQFa/1kAWgFaAFr/WQJa/VkDWv5ZAFoBWv9ZAFoBWv5ZAlr+WQFaAKYApgGm/qUBpv+lAqb/pQCmAKb/pQGmAKYBpv6lAqb+pQCmA6b9pQKm/qUBpv+lAqb+pQGmAKb/pQGmAKb/pQGmAKb/pQOm/KUDpv6lAaYBpv6lAqb+pQGmAKYApgGm/qUCpv2lBKb8pQSm/KUDpv6lAaYApgCmAKYApgCmAab+pQKm/qUBpgGm/qUCpv6lAqb+pQKm/qUCpv+lAKYApgGm/qUCpv6lAqb/pQCmAKYApgGm/qUCpv2lBKb9pQKm/qUCpv6lA6b8pQWm+6UEpv6lAKYBpv+lAab/pQGm/6UBpv+lAab/pQGmAKb+pQSm+6UFpv2lAKYCpv2lA6b+pQGmAKb+pQOm/aUDpv2lA6b8pQWm/KUDpv6lAaYApgCmAKYBpv6lAqb/pQCmAab+pQKm/6UApgCmAKYApgCmAKYApv+lA6b7pQam+6UCpgGm/aUEpv2lAqb+pQGmAKYApgGm/6UApgCmAKYBpv6lAqb+pQKm/6UApgCmAKYApgGm/qUCpv+lAKYBpv+lAKYBpv6lA6b9pQKm/6UApgGm/6UApgCmAKYApgGm/qUCpv2lBKb8pQOm/6X+pQSm/KUDpv9Z/lkEWvxZA1r+WQFaAFr/WQJa/VkDWv5ZAVoAWv5ZA1r9WQNa/lkBWv5ZA1r9WQNa/lkAWgBaAVr/WQBaAVr+WQNa/FkEWvxZBFr8WQRa/FkDWv9Z/1kDWvtZBVr8WQRa/VkBWv9ZAVoAWgBaAFoAWv+lA6b8pQSm/aUBpgGm/qUDpv2lAqb+pQKmAKb/pQGm/qUCpgCm/6UBpv6lA6b9pQOm/aUDpv2lAqb/pQGmAKb/pQCmAab/pQGm/6UApgGm/6UApgGm/6UApgGm/qUDpv2lAqb/pQGm/6UApgCmAab/pQGm/6UApgGm/6UBpv+lAab/pQKm/qUBpv+lAaYApgCm/6UBpv+lAab/pQGm/6UBpgCm/6UBpv+lAaYApgCmAKb/pQGmAKb/pQGm/6UBpv+lAab/pQGm/6UApgGm/6UBpv+lAab/pQGm/6UBpgCm/6UBpgCm/6UCpv6lAKYCpv6lAqb+pQGm/6UCpv6lAqb+pQGmAKYApgCmAKYApgCmAab+pQGmAKYApgCmAab9pQOm/aUDpv2lA6b9pQOm/aUCpv+lAab/pQCmAab/pQGm/6UBpv+lAKYBpv+lAaYApv+lAKYCpv2lA6b9pQKm/6UApgGm/qUCpv+l/6UCpv+l/6UDpvulBqb7pQOm/qUCpv6lAqb+pQKm/qUBpgGm/qUCpv6lAaYApgCmAKb/pQKm/qUBpgCm/6UCpv6lAqb+pQKm/qUCpv6lAqb/pQCmAKb/WQJa/lkBWgFa/FkFWvxZA1r+WQFa/1kBWgBa/1kBWv9ZAVr/WQFa/1kAWgFa/1kBWv9ZAFoAWgBaAlr8WQVa+lkFWv5ZAFoBWv5ZAlr/WQFa/1kAWgFa/lkDWvxZBFr9WQJa/lkCWv5ZAlr/Wf9ZA1r8pQSm/aUCpv6lAqb/pQCmAab+pQKm/qUCpv+lAKYApgCmAKYBpv6lAqb/pQGm/6UApgGm/qUDpv2lA6b9pQKm/qUCpv+lAab+pQKm/qUCpv+lAKYApgCmAKYBpv6lAqb+pQKm/6UApgGm/qUDpv2lAqb/pQCmAab/pQCmAKYBpv+lAab+pQKm/6UBpv+lAKYBpv+lAab/pQCmAKYBpv+lAab/pQCmAKYBpv+lAab/pQGm/6UBpv+lAab/pQCmAab/pQCmAab+pQKm/6UBpv+lAab/pQGmAKb/pQGm/6UCpv2lAqb+pQKm/6UBpv6lAqb+pQKm/6UApgGm/6UApgKm/aUDpv6lAab/pQKm/aUEpvulBab8pQKm/6UBpv+lAqb9pQKm/6UBpgCm/6UBpv+lAaYApv6lA6b+pQGmAKb+pQOm/qUCpv6lAKYCpv6lAqb+pQKm/aUEpvylBKb9pQKm/qUCpv6lAqb/pQCmAKYApgCmAKYApgCm/6UCpv2lBKb8pQOm/aUDpv6lAab/pQCmAqb9pQKm/6UApgGmAKb+pQKm/6UApgKm/aUCpv+lAab/pQGm/6UApgGm/6UBpv+lAFoAWgFa/1kBWv5ZAlr+WQJa/1kAWgBaAFoAWgFa/lkDWvxZBVr8WQJaAFr+WQNa/lkBWgBa/1kBWv9ZAVoAWv9ZAVr/WQFa/1kBWv9ZAVoAWv9ZAVr/WQJa/lkBWgBa/1kCWv5ZAlr+WQJa/lkCWv5ZAqb+pQKm/6X/pQKm/qUCpv+lAKYApgGm/qUDpv2lAqb/pQCmAab/pQCmAab+pQKm/6UApgGm/6UApgCmAKYBpv+lAKYApgCmAab+pQOm+6UGpvulA6b/pf+lAqb/pQCmAKYApv+lAqb/pf+lA6b7pQam+6UDpv6lAqb+pQOm/KUDpv+l/6UCpv6lAqb+pQGmAKYApgGm/qUBpgCmAKYApgGm/qUCpv6lAaYBpv6lAqb+pQKm/qUCpv6lAqb/pf+lAqb+pQOm/aUBpgCmAKYApgCmAKYApv+lAab/pQGmAKb/pQCmAab+pQSm/KUCpv+lAab/pQKm/qUApgGm/6UApgGm/6UApgGm/qUCpv6lA6b9pQGmAab+pQKmAKb+pQOm/aUCpgCm/6UCpv2lA6b+pQGmAKb/pQKm/qUBpgCmAKYApgCmAKYApgCmAab+pQKm/6X/pQOm/aUBpgGm/aUDpv6lAqb+pQKm/aUEpvylBKb8pQSm/aUBpgCmAKYApgGm/aUEpvylBab6pQWm/KUDpv+l/6UCpv2lA6b+pQGmAab9pQSm/KUDpgCm/aUEpvylA6b+pQKm/qUBpgCmAKb/pQJa/lkBWgBa/1kCWv5ZAlr9WQNa/lkBWgBa/1kBWgBa/lkEWvtZBVr8WQJa/1kCWv1ZBFr7WQRa/1n+WQRa+1kGWvpZBVr8WQNa/1n/WQFaAFr/WQJa/VkDWv5ZAVr/WQJa/VkEWvxZA1r+WQJa/VkEWv2lAaYBpv2lA6b+pQGmAKYApv+lAab/pQGmAKb/pQKm/qUBpv+lAab/pQKm/aUEpvqlB6b6pQWm/KUCpgCm/6UBpv+lAab/pQGm/6UApgGm/qUDpv2lA6b8pQSm/aUCpv+lAab+pQOm/aUCpv+lAKYBpv+lAab/pQCmAab+pQOm/aUCpv+lAKYApgCmAKYApgGm/qUBpgGm/qUCpv6lAaYBpv+lAKYApgCmAKYBpv+l/6UCpv6lAaYBpv6lAab/pQGmAKYBpv+lAKYApgGmAKb/pQKm/qUBpgGm/aUDpv6lAqb+pQGm/6UBpgCm/6UBpv6lA6b9pQOm/aUCpv6lA6b9pQKm/6UApgGm/6X/pQKm/qUDpv2lAaYApv+lAqb/pf+lAqb+pQGmAab+pQGmAKYApgGm/qUBpv+lA6b8pQSm/KUDpv6lAqb+pQKm/qUBpgCmAab+pQKm/qUBpgGm/qUCpv6lAqb+pQKm/qUCpv6lAqb+pQKm/qUCpv2lA6b+pQGmAKb/pQCmAab/pQGmAKb+pQOm/aUDpv6lAKYBpv6lA6b+pQCmAab+pQKmAKb+pQOm/aUBpgGm/6UBpv6lAqb+pQNa/VkCWv5ZA1r9WQJa/1kAWgFaAFr+WQJa/lkCWv9ZAVr+WQJa/lkCWv5ZAlr+WQFaAFoAWgBa/1kBWgBaAFoAWgBa/1kCWv5ZAVoBWv5ZAlr9WQNa/lkCWv5ZAlr+WQFa/1kCWv5ZAlr/Wf9ZAlr/WQCmAab/pQCmAKYBpv6lA6b+pf+lA6b8pQSm/qUApgCmAab+pQKm/qUCpv6lAqb+pQGmAKYApgCmAKYApgCmAKYBpv6lAqb/pQCmAKYApgCmAab+pQKm/qUCpv+lAKb/pQOm/KUFpvqlBab8pQSm/aUCpv6lAqb+pQKm/6X/pQKm/6X/pQKm/aUDpv6lAqb9pQOm/aUDpv6lAab/pQGm/6UBpv+lAKYApgGm/qUDpv2lAqYApv6lA6b9pQKmAKb/pQGmAKb+pQOm/aUDpv6lAKYCpv2lA6b9pQOm/qUCpv2lAqb/pQKm/qUBpgCm/qUEpvylAqYApv+lAqb9pQOm/aUCpgCm/qUDpv2lAqb/pQGm/6UBpv+lAKYBpv+lAaYApv6lA6b9pQOm/qUApgGm/6UBpv+lAKYBpv6lA6b9pQKm/6UApgGm/qUCpv+lAKYBpv+lAKYBpv6lA6b9pQOm/aUDpv6lAab/pQGmAKb/pQKm/aUDpv2lA6b+pQCmAqb8pQSm/qUApgGm/qUCpv+lAKYBpv6lA6b9pQKm/6UApgGm/6UApgGm/qUDpv2lAaYBpv6lA6b8pQSm/aUCpv6lAqb/WQFa/1kAWgFa/1kBWv9ZAVoAWv9ZAVr+WQRa/FkDWv5ZAFoCWv5ZAVoAWv9ZAlr+WQFaAFoAWv9ZAlr9WQNa/lkBWgBa/1kBWv9ZAlr9WQNa/lkBWgBa/1kBWgBaAFr/WQJa/lkCWv5ZAVoAWgBaAFoApgCm/6UBpv+lAqb+pQGm/6UApgKm/aUDpv2lA6b+pQCmAab/pQGmAKb+pQOm/aUCpv+lAKYBpv+lAKYApgCmAKYApgCmAKYApgCmAKYApv+lAqb9pQSm/aUBpgCm/6UBpgCm/6UCpv2lA6b+pQGm/6UBpgCm/6UCpv2lAqb/pQCmAKYCpvylBKb7pQWm/aUDpvylA6b9pQSm/KUEpvylAqYApv+lAqb+pQGmAKb/pQGmAKb/pQKm/aUDpv6lAKYBpv+lAab/pQGm/qUDpv2lAqYApv+lAab/pQGmAKYApgCm/6UBpgCm/6UCpv6lAKYCpv2lA6b+pQGmAKb/pQKm/qUCpv6lAqb+pQOm/aUCpv+lAKYBpv+lAab/pQGm/6UBpv+lAqb+pQKm/qUBpgCmAKYBpv6lAab/pQGmAab9pQOm/aUDpv6lAaYApv+lAaYApgCmAab+pQKm/qUCpv+lAab+pQKm/6UApgGm/qUCpv6lAqb/pf+lA6b8pQOm/6X/pQKm/qUCpv6lAaYApgCmAKYApgCmAKYBpv6lAqb/pQCmAab/pQCmAKYBpv+lAab/pQCmAab+pQOm/aUDpv2lA1r9WQNa/lkBWgBaAFoAWgBaAFr/WQJa/lkCWv5ZAlr9WQRa/FkEWv1ZAlr+WQJa/lkDWvxZBFr8WQRa/VkBWgBaAFoBWv9ZAFoAWgBaAVr/WQFa/lkCWv5ZA1r8WQVa+lkGWvtZBFr9WQJaAFr/WQFa/6UApgGm/6UCpv2lA6b9pQKmAKb/pQKm/aUDpv2lA6b9pQOm/aUDpv6lAKYBpv+lAaYApv+lAaYApv+lAab/pQGm/6UBpv+lAab/pQGm/6UBpv+lAaYApv+lAqb9pQKmAKb/pQGmAKb/pQGm/6UBpv+lAqb9pQOm/aUDpv6lAKYBpv+lAab/pQGm/6UBpv+lAKYBpgCm/6UBpv+lAaYApv+lAqb+pQKm/qUBpgGm/qUCpv6lAqb/pQCmAKYApgCmAab/pQCmAKYBpv6lA6b9pQGmAqb8pQSm/aUCpv6lAqb/pQCmAab9pQSm/aUCpv+l/6UDpvylBab6pQWm/aUCpgCm/6UApgCmAaYApv+lAqb9pQOm/qUBpv+lAqb9pQOm/qUBpgCm/6UBpgCm/6UCpv6lAaYApv+lAqb+pQKm/aUDpv+l/6UCpv6lAaYApv+lAab/pQGm/6UBpv+lAKYApgCmAab+pQOm/KUEpv2lAqb/pQGm/qUDpvylBKb+pQGm/qUDpvylBKb+pQCmAqb9pQKm/6UBpgCm/6UBpv+lAab/pQGm/6UBpv+lAab/pQGm/6UBpv+lAab/pQCmAqb9pQNa/VkCWv9ZAlr9WQNa/VkCWgBa/1kBWv9ZAVoAWv9ZAFoBWgBaAFr/WQBaAVr/WQJa/FkFWvtZBFr9WQJa/lkCWv5ZAlr+WQFaAFr/WQJa/lkCWv5ZAlr+WQJa/1kBWv9ZAFoBWv5ZAlr/WQBaAVr+WQKm/qUBpgGm/aUEpv2lAaYApv+lAaYApgGm/aUDpv6lAaYApgCm/6UCpv6lAab/pQGmAKb/pQKm/KUFpvylA6b9pQOm/aUDpv6lAaYApv6lA6b9pQOm/qUBpgCm/6UBpgCm/6UCpv6lAqb9pQOm/qUCpv+l/6UCpv2lBab6pQam+qUFpv2lAaYApv+lAqb+pQGmAKb/pQKm/qUBpv+lAqb+pQGmAKb/pQGmAKb/pQGmAKb/pQGm/6UBpv+lAqb8pQWm/KUDpv2lAqYApv+lAqb8pQSm/aUDpv2lAqb/pf+lA6b8pQSm/aUCpv+l/6UCpv6lAqb+pQGmAKb/pQGm/6UBpgCm/6UCpv2lBKb7pQam+6UDpv+lAKYApgCmAKYApgCmAKb/pQKm/qUCpv2lA6b+pQGmAKb/pQGmAKb+pQOm/aUDpv2lAqb/pQCmAab/pQCmAab/pQCmAab+pQKm/6UApgCmAab+pQKm/qUCpv+lAKYBpv6lA6b9pQKm/6UApgGm/6UApgCmAab/pQGm/qUCpv+lAab/pQCmAKYApgCmAKYApgCm/6UCpv2lBKb8pQKmAab9pQSm/KUDpv2lA6b9WQNa/lkBWv9ZAVr/WQFa/1kBWv9ZAVr/WQFa/1kBWv9ZAVoAWv9ZAVoAWv5ZBFr8WQJaAFr+WQRa/FkCWv9ZAVoAWgBa/1kBWv9ZAlr+WQFaAFr/WQJa/VkDWv1ZA1r+WQBaAVr/WQBaAFoBWv5ZA1r8pQOm/6UApgGm/qUBpgGm/6UApgCmAKYApgGm/qUBpgCmAKYApgCmAKYApv+lAqb+pQKm/qUBpv+lAqb+pQGmAKb/pQGm/6UCpv2lBKb7pQWm/KUCpgCm/6UBpgCm/6UBpgCm/6UBpgCm/6UBpv+lAab/pQGm/qUDpv2lAqb/pQCmAab/pQGm/qUDpv6lAKYCpv2lA6b+pQGmAKb/pQKm/qUBpgGm/aUEpv2lAaYApv+lAqb/pQCmAKb/pQKm/qUDpv2lAaYBpv6lAqb/pQCmAab/pf+lAqb/pQGm/6UApgCmAab+pQOm/KUEpv2lAqb/pQCmAKYApgGm/qUDpvylBKb9pQKm/qUCpv6lA6b8pQSm/KUEpv2lAqb+pQKm/6UApgGm/qUCpv6lAqb/pf+lAqb9pQOm/6X/pQKm/qUBpgCmAKYBpv+lAKYApgCmAab/pQCmAKYApgCmAab+pQKm/qUCpv6lAqb+pQOm/KUEpvylBKb9pQKm/6UApgGm/qUDpv6lAab/pQCmAaYApv+lAab+pQOm/aUDpv2lAqb/pQGm/6UBpv+lAab/pQCmAaYApv+lAab+pQKmAKb/pQGm/1kAWgFa/1kBWv9ZAFoBWv9ZAVr/WQBaAVr+WQNa/VkCWv5ZA1r8WQRa/FkEWv1ZAlr+WQJa/1kAWgBaAVr+WQNa/FkEWv1ZAlr/WQBaAVr/WQBaAVr/WQFa/1kAWgFa/1kAWgFa/lkCWv9ZAFoBWv9ZAFoBpv+lAaYApv+lAab/pQGm/6UCpv2lA6b9pQOm/qUBpgCm/6UBpgCm/6UCpv6lAaYApv+lA6b7pQam+qUFpvylA6b+pQGmAKb+pQSm+6UFpvulBab8pQOm/qUBpv+lAaYApv+lA6b6pQem+qUFpvylA6b+pQGmAKYApgCmAKYApgCmAKYBpv6lA6b9pQKm/6UApgGm/6UBpv+lAab/pQGm/6UCpv6lAaYApgCmAKYBpv2lBab6pQem+aUGpvylAqb/pQGm/6UBpv+lAKYCpv6lAab/pQGmAKYApgCm/6UCpv2lA6b+pQGmAKb/pQGm/6UCpv2lA6b+pQCmAaYApv+lAqb9pQOm/qUCpv6lAqb+pQKm/qUCpv+lAKYBpv6lAqb/pQCmAKYApgCmAab+pQGmAKYApgCmAKb/pQKm/qUBpgCm/6UCpv2lA6b/pf+lAqb9pQSm/aUCpv6lAaYApgCmAab+pQKm/aUDpv+l/6UCpv6lAaYApgCmAKYApgCmAKYApgGm/qUCpv+lAKYApgCmAKYApgGm/aUDpv6lAqb+pQGm/6UCpv6lAab/pQGmAKb/pQGmAKb/pQGmAKb+pQOm/lkBWgBa/lkDWv5ZAVoAWv9ZAVoAWgBa/1kCWv5ZAVoBWv5ZAVoBWv9ZAVr/WQFa/1kCWv1ZA1r+WQFa/1kBWv9ZAVoAWv9ZAVr/WQFa/1kCWv1ZA1r9WQNa/VkCWv9ZAVr/WQFa/lkDWv1ZA1r+WQBaAab+pQSm/KUCpv+lAab/pQKm/KUFpvulBab8pQOm/aUCpgCm/6UCpv6lAaYApv+lAqb+pQKm/qUBpv+lAqb+pQGm/6UBpv+lAqb+pQCmAqb9pQOm/qUBpv+lAqb9pQOm/qUBpgCm/6UCpv6lAqb+pQGmAKYApgGm/qUBpgCmAKYBpv6lAaYApgCm/6UCpv2lA6b/pf6lBKb7pQWm/KUDpv6lAqb9pQSm/KUCpgGm/qUCpv+l/6UCpv6lAqb/pQCmAab9pQSm/aUCpv6lAqb/pQCmAKYApgGm/qUCpv6lAaYBpv6lAqb+pQKm/qUCpv+lAKYApgCmAab+pQOm/KUEpv2lAqb/pQGm/qUDpvylBKb9pQKm/6UApgCm/6UCpv6lA6b8pQOm/qUBpgGm/qUCpv6lAqb/pQCmAKYBpv+lAab+pQKm/6UCpvylBab6pQam/KUCpgCm/qUDpv2lA6b9pQKm/qUDpv2lAqb+pQGmAKYApv+lAqb+pQGmAKb/pQKm/6UApgCmAKYBpv+lAKYBpv6lA6b9pQGmAab+pQKm/6X/pQKm/qUCpv+lAKYApgCmAKYBpv+lAKYApv+lA6b9pQJa/lkCWv9ZAVr/WQBaAVr+WQNa/VkCWv9ZAFoBWv5ZA1r9WQJa/1kAWgFaAFr/WQBaAVr+WQRa+1kEWv1ZAloAWv9ZAVr+WQJaAFr/WQFa/1kAWgJa/VkDWv1ZAloAWv9ZAVoAWv9ZAVr/WQFaAFr/WQGm/6UBpgCm/6UBpv+lAKYBpv+lAab/pQCmAKYApgGm/6UBpv6lAaYBpv+lAab+pQGmAKYBpv6lAaYApgCmAab+pQKm/6UApgCmAab+pQOm/aUBpgCmAKYApgGm/qUBpgCmAab+pQKm/qUCpv+lAKYApgCmAab+pQKm/qUCpv+lAKYApgCmAab/pQCmAKYApgGmAKb+pQOm/KUFpvulBKb9pQKmAKb/pQCmAab/pQGmAKb/pQKm/aUDpv6lAaYBpv2lA6b+pQGmAab9pQOm/qUBpgCmAKb/pQGmAKb/pQKm/aUEpvylBKb8pQOm/qUCpv+lAab+pQKm/qUCpv+lAab/pQCmAKb/pQOm/aUCpv+l/6UCpv6lAqb/pQCmAKYApgCmAKYBpv+lAKYBpv2lBab7pQSm/aUBpgCmAab+pQKm/aUEpvylBKb9pQGmAKYApgCmAab+pQGmAKYBpv6lAqb+pQKm/6UApgCmAKYApgCmAab+pQKm/qUBpgGm/qUBpgGm/qUCpv6lAaYApgCmAab+pQGmAKYApgCmAKb/pQKm/qUBpv+lAaYApgCm/6UApgGmAKb/pQKm/aUDpv+l/6UCWv5ZAlr+WQNa/FkEWv1ZAVoAWgBaAFoAWgBaAFoAWgBa/1kCWv5ZA1r8WQNa/lkBWgBa/1kBWv9ZAVr/WQFa/1kAWgFa/lkDWv1ZA1r9WQNa/VkDWv1ZA1r+WQFaAFr/WQFaAFr/WQFa/1kBWgBa/1kBpv+lAaYApv+lAaYApv+lAab/pQGmAKb/pQGm/6UBpgCmAKYApv+lAaYApgCmAKb/pQGmAKYApgCm/6UBpgCmAKb/pQKm/aUDpv6lAab/pQGm/6UApgKm/aUCpv+lAKYBpv+lAKYApgGm/6UApgCm/6UDpv2lAqb+pQGmAKYBpv6lAqb+pQKm/6UBpv6lAqb/pQCmAab+pQKm/6UApgCmAab/pQCmAab+pQKm/6X/pQOm/aUBpgGm/aUEpv6lAKYBpv+lAKYBpv+lAKYBpv6lAqb+pQOm+6UGpvulA6YApv6lA6b9pQKm/6UBpgCm/qUDpv2lA6b+pQCmAab/pQGm/6UBpv+lAab/pQGm/6UApgKm/aUDpv6lAKYBpv+lAaYApv+lAab/pQGm/6UCpv2lBKb8pQKmAKb/pQKm/aUDpv2lA6b9pQOm/aUDpv6lAKYCpv2lA6b+pQCmAqb9pQOm/aUDpv2lA6b+pQCmAaYApv6lBKb7pQWm/KUDpv6lAaYApgCmAKYApgCm/6UCpv6lAaYApv+lAqb+pQGmAKYApgGm/qUCpv6lAqb+pQKm/qUDpvylBKb8pQSm/aUDpv2lAlr/WQBaAVr/WQBaAFoAWgFa/lkCWv5ZAVoBWv5ZAlr/Wf9ZAlr/WQBaAlr8WQRa/VkDWvxZBVr7WQVa/FkCWv9ZAVoAWgBaAFr/WQFa/1kCWv1ZBFr7WQVa/FkDWv5ZAVoAWgBaAFoAWgBaAFoAWgBaAab+pQKm/qUCpv+lAKb/pQOm+6UGpvqlBKb/pQCm/6UBpv+lAaYBpv6lAab/pQGmAKb/pQKm/aUEpvulBab7pQSm/qUBpv+lAab+pQOm/aUDpv6lAKYBpv+lAqb+pQGm/qUDpv6lAqb9pQOm/qUBpgCm/6UCpv+l/6UCpv6lAqb+pQKm/aUEpv2lAaYBpv6lAqb+pQKm/qUDpv2lAaYBpv2lBKb9pQGmAab9pQOm/6X/pQOm/KUDpv6lAqb/pQCmAKb/pQKm/qUCpv6lAqb+pQGmAKYApgGm/qUCpv6lAqb/pQCmAab+pQKm/qUCpv6lAqb+pQKm/qUCpv6lAqb/pQGm/6UApgCmAab/pQKm/aUCpv+lAKYBpv+lAab+pQOm/aUCpv+lAab/pQGm/6UApgKm/aUCpv+lAab/pQGm/qUDpv6lAab/pQGm/6UBpgCm/6UCpvylBab7pQWm/KUBpgGm/qUDpvylBKb8pQSm/aUCpv+lAKYBpv6lBKb7pQSm/qUApgGmAKb/pQGmAKb/pQKm/qUCpv6lAqb+pQKm/6UApv+lAqb+pQKm/qUBpv+lAqb+pQGmAKYApgCmAKYApgBaAFoBWv5ZA1r9WQJa/1kBWv9ZAVr/WQFa/1kCWv1ZA1r+WQFaAFr/WQJa/lkCWv5ZAVoAWgFa/lkCWv5ZAVoBWv5ZAlr+WQJa/lkDWvxZBFr9WQJaAFr+WQNa/VkDWv5ZAVr/WQJa/lkBWgBa/1kCWv6lAqb+pQGmAKYApgCmAab+pQKm/qUCpv+lAab+pQKm/qUDpv2lAqb/pQCmAKYApgCmAKYBpv6lAqb+pQKm/qUDpv2lAqb/pQCmAKYBpv6lAqb+pQKm/6UApgCmAKYApgGm/qUCpv6lAqb/pf+lAqb+pQKm/6UApv+lAqb/pQCmAab+pQKm/qUCpv+l/6UDpvylBab7pQOm/qUDpv2lAqb/pQCmAab+pQOm/KUEpv2lAqb/pQCmAab+pQOm/aUCpgCm/qUDpv2lA6b+pQCmAqb8pQWm/KUCpgCm/qUDpv2lA6b+pQCmAab/pQGm/6UApgGm/6UBpv+lAKYCpv2lA6b9pQOm/qUBpv+lAab/pQGmAKb/pQGm/6UApgGmAKb/pQGm/6UApgGm/qUDpv2lA6b8pQSm/aUCpgCm/qUDpv2lAqb/pQGm/qUDpvylBab7pQOm/6UApgGm/6UBpv6lAqb/pQGm/6UBpv6lA6b9pQKm/6UApgGm/qUCpv6lAqb+pQKm/6UApgCmAab/pQGm/6UApgGm/6UBpv+lAab+pQOm/aUDpv6lAab/pQGm/6UBpgCm/6UBpv+lAKYCpv2lA6b9pQJa/1kBWv9ZAVr/WQBaAVr/WQFa/1kAWgFa/1kBWv9ZAFoBWv9ZAVr+WQJa/lkDWv1ZAlr+WQNa/FkFWvpZBlr7WQNa/1kAWv9ZAlr9WQRa+1kFWvxZA1r+WQFa/1kBWgBa/1kBWv9ZAFoCWv1ZAlr/WQGmAKb+pQKm/6UCpv6lAab+pQOm/qUBpgCm/6UCpv6lAab/pQGmAab/pf+lAaYApgCmAKYApv+lA6b9pQKm/6UApgGmAKb+pQOm/qUApgKm/aUDpv6lAKYCpv2lA6b+pQGm/6UCpvylBab8pQOm/qUBpv+lAab/pQKm/qUApgKm/aUDpv+l/qUEpvylA6b/pQCmAKYApgCmAKYBpv6lA6b8pQSm/KUEpv2lAaYApgCm/6UCpv6lAKYCpv2lBKb7pQWm+6UFpv2lAKYBpgCm/6UCpv2lAqYBpv2lA6b9pQKm/6UBpv6lA6b9pQKm/6UBpv6lA6b+pQCmAqb9pQOm/qUBpgCm/6UCpv2lA6b+pQGm/6UBpv+lAaYApv+lAaYApv+lAqb+pQGmAKb/pQKm/qUBpgCm/6UCpv6lAqb+pQGmAKYApgGm/qUBpgCmAKYBpv2lBKb8pQSm/KUDpv+lAKYApv+lAaYBpv2lBKb7pQWm/KUDpv6lAaYBpv6lAqb+pQGmAab/pQGm/qUCpv+lAKYBpv+lAKYCpv2lA6b+pQGmAKYApv+lAqb+pQGmAKb/pQKm/qUBpgCm/6UCpv6lAaYBWv5ZAVoAWv9ZAlr/WQBaAFoAWgBaAVr/WQBaAVr+WQNa/FkEWv1ZAlr+WQNa/VkDWv1ZAloAWv9ZAVr/WQBaAVr/WQFa/1kAWgFa/lkDWv1ZA1r+WQBaAFoBWv9ZAlr9WQJaAFr+WQRa+lkHWvlZB1r5pQam+6UEpv2lAqb/pQCmAKYApgGm/qUCpv6lAqb/pQGm/qUCpv+lAab/pQCmAKYApgGm/6UApgGm/qUCpv+lAKYBpv6lA6b8pQSm/KUEpv2lAqb+pQKm/qUCpv6lAqb+pQKm/aUDpv6lAaYApv+lAab/pQGm/6UCpv2lA6b+pQCmAqb+pQGmAKYApv+lAqb+pQGmAab+pQKm/qUCpv+lAKYApgCmAKYApgGm/aUEpvylAqYApv+lAaYApgCm/qUDpv2lA6b+pQGm/6UBpgCm/6UBpv+lAaYApgCm/6UBpgCm/6UDpvulBab8pQOm/6X/pQKm/aUEpv2lAaYBpv6lAqb/pQCmAKYBpv6lA6b8pQSm/aUCpv+lAKYBpv+lAab/pQGm/qUDpv2lA6b+pQCmAab/pQKm/aUDpv2lA6b+pQKm/aUEpvulBKb+pQGmAKb/pQGm/6UCpv2lBKb8pQOm/qUBpgCmAKYApgCmAKYApgCmAKYApgGm/qUCpv+lAKYBpv6lAqb/pQCmAab+pQKm/6UApgGm/qUCpv+lAKYCpvylBKb9pQKmAKb+pQKm/qUCpv+lAKYApgCmAKYApgCmAFoAWgBaAVr+WQJa/1kAWgFa/lkCWv9ZAVr/WQBaAFoBWv5ZA1r9WQJa/1kBWv9ZAVr/WQFaAFr/WQBaAlr9WQNa/lkAWgFa/1kBWgBa/1kBWgBa/1kCWv1ZA1r+WQFa/1kBWv5ZAlr/WQBaAFoAWgBaAKYApv+lAqb+pQKm/aUDpv+lAKYApv+lAqb/pQCmAab9pQSm/KUDpv+lAKYApgCm/6UCpv6lAqb/pf+lA6b7pQam+6UDpv+lAKb/pQOm/KUEpv2lAqb/pQCmAKYBpv+lAab+pQKm/6UBpv+lAKYBpv6lA6b9pQKm/6UApgCmAab+pQOm/aUCpv+lAab/pQGm/6UBpv+lAab/pQGmAKb/pQGm/6UBpgCmAKb/pQKm/aUEpvylAqYApv+lAqb+pQGm/6UBpgCm/6UCpv6lAKYCpv2lA6b+pQCmAab/pQGmAKb+pQOm/aUDpv6lAKYBpv+lAab/pQGm/6UCpv6lAaYApv+lA6b8pQSm/KUDpv6lAqb+pQKm/qUBpgCm/6UCpv6lAaYApv+lAaYApv+lAqb+pQGmAKYApgGm/qUCpv6lA6b+pQGm/6UApgGmAKb/pQKm/aUDpv2lA6b9pQOm/aUDpv2lA6b9pQKm/6UBpgCm/6UBpv6lA6b+pQKm/aUDpv2lA6b+pQGm/6UBpv+lAab/pQGm/6UApgGm/6UBpv+lAKYBpv+lAqb9pQOm/aUCpgCmAKb/pQGm/6UBpgCm/qUDpv5ZAVoAWv5ZA1r+WQFa/1kBWv9ZAVr/WQFa/1kBWv9ZAVr/WQFaAFr/WQFaAFr+WQRa+1kFWvtZBFr+WQBaAVr/WQBaAlr9WQJaAFr/WQJa/VkDWv5ZAlr+WQJa/VkDWv5ZAVoAWgBa/1kBWv9ZAVoAWv+lAab/pQGm/6UBpv+lAqb+pQCmAab/pQKm/6X/pQGm/6UBpgCmAKb/pQGm/6UBpv+lAab+pQOm/aUCpv+lAKYBpv+lAKYApgCmAab+pQOm/KUEpv2lAaYApgGm/6UApgGm/aUEpv2lAaYBpv6lAqb+pQGmAab+pQKm/qUBpgGm/qUCpv6lAqb+pQKm/qUCpv6lAqb+pQGmAKb/pQKm/qUBpgCm/6UBpv+lAqb+pQGm/6UApgKm/aUDpv2lA6b9pQOm/aUCpv+lAab/pQKm/aUDpv2lA6b+pQKm/qUBpv+lAab/pQGm/6UBpgCm/qUDpv2lAqYApv6lA6b9pQKm/6X/pQOm/aUCpv+l/6UDpvylBKb9pQKm/6UApgCmAab/pQGm/qUCpv+lAKYBpv6lAqb/pQCmAab/pQGm/6UBpgCm/6UBpgCm/6UBpgCm/6UCpv6lAaYApgCmAKb/pQKm/qUBpgCm/6UBpgCm/qUEpvulBKb9pQKm/6UApgGm/qUDpvylBKb9pQKm/6UApgCmAab/pQGm/6UApgGm/6UBpv+lAab/pQGm/6UApgGm/qUDpv2lAqb/pQCmAKYBpv6lAqb/Wf9ZA1r8WQRa/VkBWgFa/1kAWgFa/1kBWv9ZAVr+WQNa/VkCWv5ZAlr+WQJa/lkCWv5ZA1r8WQRa/VkCWv9ZAFoBWv9ZAFoAWgBaAVr/WQBaAFoAWgBaAFoAWgBaAVr+WQJa/1kBWv9ZAVr/WQJa/lkBpv+lAaYApgCm/6UBpv+lAaYApv+lAaYApv+lAqb+pQGmAab9pQSm/KUDpv+l/6UBpv+lAaYApv+lAab/pQGm/6UBpgCm/6UBpv+lAab/pQGm/6UBpgCm/6UBpv+lAqb+pQGm/6UBpgCmAKb/pQGmAKb/pQGmAKb/pQOm+6UEpv6lAaYBpv2lA6b9pQOm/6UApgCm/6UCpv6lAqb/pQCmAab/pQCmAab/pQKm/qUCpv6lAaYBpv2lBKb8pQOm/qUApgGm/qUDpv2lAaYBpv6lAqb/pQCmAab+pQKm/6UApgKm/KUEpv6lAab/pQCmAab/pQKm/aUCpv+lAab/pQKm/KUFpvylA6b+pQGm/6UBpgCm/6UBpv+lAKYBpv6lAqb/pQCmAab+pQOm/aUDpv6lAKYCpv2lBKb8pQKmAKb/pQKm/qUBpgCm/6UCpv+lAKYApgCmAKYBpv6lAqb+pQKm/qUCpv6lAqb+pQGmAKb/pQOm/KUDpv6lAaYApgCm/6UCpv2lBKb8pQOm/qUApgGmAKb/pQGm/6UApgGmAKb+pQSm+6UFpvylAqYApv+lAab/pQGm/6UBpv+lAKYCpv2lBKb7WQRa/lkBWgBa/1kBWv9ZAlr9WQNa/lkBWgBa/lkDWv5ZAVr/WQFa/lkDWvxZBVr7WQVa+1kDWv9ZAVr/WQFa/lkDWv1ZAloAWv9ZAlr9WQNa/lkBWgBa/1kCWv5ZAVr/WQFa/1kBWv9ZAVr/WQBaAFoApgGm/6UApgCmAKYApgGm/6UApgGm/qUDpv2lAqb/pQCmAab+pQOm/aUCpv6lA6b9pQSm+6UFpvylA6b+pQGmAab9pQSm/KUDpv6lAab/pQKm/aUCpgCm/qUDpv2lAqb/pQGm/qUDpv6lAKYBpv+lAKYCpvylBKb9pQKm/6UApgGm/qUCpv+lAKYApgGm/qUCpv6lAqb+pQKm/6UApgCmAKYApgGm/6UApgCmAKYApgGm/qUCpv+l/6UDpvylBKb9pQOm/KUEpv2lAqb/pQCmAKYBpv6lA6b8pQSm/aUCpv+lAKYApgGm/6UApv+lAqb+pQKm/qUBpv+lAqb9pQOm/qUApgKm/aUDpv6lAab/pQKm/qUBpv+lAab/pQKm/qUBpv+lAab/pQKm/qUBpv+lAaYApv+lAab/pQGmAKb/pQGm/6UBpgCm/6UCpv2lAqYApv+lAaYApv6lA6b9pQKmAKb/pQCmAab/pQCmAqb8pQWm/KUCpgCm/6UBpv+lAab/pQGm/6UBpv+lAab/pQCmAqb8pQam+aUFpv6lAKYBpv+lAKYBpv+lAaYApv6lA6b9pQOm/qUBpv+lAab/pQKm/VkDWv5ZAVoAWv9ZAVoAWgBaAFr/WQFaAFr/WQJa/VkEWvxZA1r+WQFaAFoBWv5ZAlr/Wf9ZA1r9WQJa/1kAWgBaAlr8WQVa+1kDWgBa/lkDWvxZBFr8WQRa/FkEWvxZA1r+WQFaAFoAWv9ZAlr+WQBaAqb+pQGmAKb/pQKm/aUDpv6lAaYBpv2lA6b+pQKm/6UApgCmAKYBpv+lAab/pQCmAKYBpv6lA6b8pQOm/6UApgCm/6UCpv6lAqb+pQGmAKb/pQKm/qUCpv6lAqb+pQKm/qUCpv+lAab+pQKm/6UApgGm/qUCpv6lA6b9pQKm/6UApgGm/6UBpv+lAKYApgGm/6UApgCmAKYApgGm/aUFpvqlBab+pf+lA6b8pQOm/6X/pQKm/6UApgCmAKb/pQOm/KUEpv2lAqb+pQKm/qUCpv6lAqb+pQKm/aUDpv2lA6b/pf+lAab/pQGmAKYApv+lAqb+pQGmAKYApgCmAKYApgCmAKYBpv6lAqb/pQCmAab+pQKm/6UBpv+lAKYBpv+lAab/pQGm/6UBpv+lAKYBpv6lA6b9pQKm/qUCpv+lAKYApgCmAab+pQOm/KUEpv2lAqb+pQKm/6UApgCmAKYApgGm/6UApgCmAKYBpv+lAab/pQCmAab/pQGmAKb+pQOm/aUDpv6lAab/pQGm/6UCpv2lBKb7pQam+qUFpvulBKb/pf+lAqb9pQOm/qUCpv6lAqb+pQKm/qUCpv+l/6UDpvxZBFr8WQNa/1kAWgFa/VkDWv5ZAlr+WQJa/lkCWv5ZAVoAWv9ZAVoAWv9ZAVr+WQJaAFr/WQFa/lkCWgBa/1kBWv9ZAFoBWgBa/1kBWv9ZAVr/WQFa/1kAWgFa/lkDWv1ZAlr/WQBaAVr/WQFa/1kBWv+lAKYApgGm/6UBpv+lAKYBpv6lA6b+pQGm/6UApgGm/6UCpv2lA6b9pQOm/qUCpv2lA6b+pQGmAKb/pQGmAKYApv+lAaYApgCmAKYApgCmAKYApgCmAab+pQGmAab9pQSm/KUDpv+lAKYApgCmAKYBpv+lAab+pQKm/6UApgCmAKYApgCmAKYApgCmAab+pQKm/qUDpvylBKb8pQSm/aUCpv+l/6UDpv2lA6b9pQKm/qUCpv+lAKYApv+lAab/pQKm/qUBpgCm/6UCpv2lBKb8pQSm/KUDpv6lAaYApgCmAKYApv+lAqb+pQKm/qUCpv2lBKb8pQOm/6X/pQKm/qUCpv6lAqb9pQSm/KUEpvylAqb/pQGmAKYApv6lA6b+pQGmAab8pQWm/KUEpvylA6b+pQGmAKb/pQGmAKb/pQKm/aUDpv2lA6b9pQOm/aUDpv2lA6b8pQSm/aUDpv6lAKYBpv6lA6b+pQGmAKb/pQGm/6UBpgCm/6UBpv+lAab/pQGm/6UBpgCm/6UCpv6lAaYApgCmAKb/pQKm/aUEpvylA6b9pQOm/aUEpvylA6b9pQKm/6UCpvylBab7pQOmAKb+WQJa/1kAWgFa/1kAWgFa/1kBWv9ZAFoCWv1ZA1r9WQNa/lkAWgFa/lkDWv1ZAlr+WQNa/VkCWv5ZAlr/WQFa/1kAWgFa/1kBWv9ZAVoAWv9ZAVr/WQJa/VkDWv1ZAloAWv9ZAVr/WQFa/1kBWgBa/1kCpv2lBKb8pQOm/6X/pQKm/qUBpgGm/qUCpv6lAqb/pQCmAKYApgGm/6UApgCm/6UCpv+lAKYApgCm/6UCpv6lAaYApv+lAaYApv+lAab/pQKm/aUEpvulBqb6pQWm/KUDpv+l/6UBpgCmAKb/pQKm/qUCpv6lAaYApgCmAKYApv+lAqb+pQGmAKb/pQKm/qUBpv+lAab/pQGm/6UBpgCm/qUDpv2lA6b9pQOm/aUCpv+lAKYApgGm/qUCpv+l/6UDpv2lAqb/pQCmAqb9pQKmAKb+pQWm+aUHpvmlB6b6pQWm/KUCpv+lAab/pQGm/6UApgGm/qUDpv2lAqb/pQCmAab+pQKm/6UApgGm/qUCpv6lAqb+pQKm/6UApgCmAKYApgCmAKYApgCmAKYApv+lAaYApgCmAKYApv+lAaYApv+lA6b8pQOm/qUBpgCmAKYApgCmAKYApgCmAKYApgCm/6UDpvylBKb8pQOm/6X/pQKm/qUCpv6lAqb+pQGmAab9pQSm/aUBpgGm/aUEpvylA6b/pf+lAqb9pQOm/qUBpv+lAaYApgCm/6UBpv+lAqb+pQGmAKYApv+lAqb9pQOm/1n/WQFa/1kBWgBa/1kBWv5ZBFr8WQNa/lkBWgBaAFoAWgBaAFoAWgBaAFoAWv9ZA1r7WQZa+lkEWv5ZAVoAWgBa/1kCWv1ZBFr8WQRa/FkEWv1ZAlr/WQBaAFoBWv9ZAVr/WQBaAVr/WQFa/1kBWv5ZA6b8pQWm+6UEpv2lAaYBpv+lAKYCpvylBKb+pQCmAqb+pQCmAqb9pQOm/qUBpv+lAqb9pQKmAKb/pQGmAKb/pQGmAKb/pQKm/qUBpgCmAKYApgCmAKb/pQOm/KUEpvylA6b+pQKm/qUCpv2lBKb8pQOm/qUBpgCmAab9pQOm/qUBpgGm/qUCpv+lAKYApgCmAab+pQOm/aUCpv+lAKYApgGm/qUDpv2lAqb/pQCmAab/pQCmAab/pQGm/6UApgGm/6UBpv+lAKYBpv+lAab/pQGm/qUCpv+lAab/pQCmAKYApgGm/6UApgCmAab+pQOm/KUEpv2lAqb+pQKm/6UApgCmAKYApgGm/qUCpv+l/6UCpv6lAqb/pf+lAaYBpv6lA6b8pQOm/6UApgCmAKYBpv6lAqb+pQKm/6UBpv6lAqb/pQCmAab/pQCmAab+pQKm/6UBpv+lAab+pQKm/6UApgCmAKYApgCmAKYApgCmAKYApgCmAKYBpv+lAKYBpv6lAqb/pQGm/6UBpv+lAKYBpgCm/6UBpgCm/qUDpv6lAKYCpv2lA6b9pQOm/aUDpv6lAKYCpv6lAab/pQGm/6UBpgCm/lkDWv1ZAlr/WQFa/1kAWgFa/lkDWv1ZAlr/WQFa/1kAWgFa/lkDWv1ZAlr/WQBaAVr+WQNa/VkCWv9ZAVr/WQBaAVr/WQFa/1kAWgFaAFr/WQFa/lkDWv5ZAlr+WQFa/1kBWgBaAFoAWv9ZAVr/WQJa/qUCpv6lAKYCpv2lBKb8pQOm/aUCpv+lAab/pQGm/6UBpv+lAab/pQKm/qUCpv2lBKb9pQGmAab+pQOm/aUBpgGm/qUDpv2lAqb/pQGm/qUDpv2lAqb/pQGm/6UBpv+lAab/pQGm/6UBpv+lAab/pQGm/6UApgCmAqb9pQSm+6UFpvylBKb8pQOm/6UApgCm/6UBpgCmAKb/pQGm/6UBpgCm/6UBpgCm/qUEpvulBab8pQKmAKYApv+lAqb9pQOm/6UApgCmAKb/pQKm/qUCpv6lAaYBpv2lBKb9pQKm/6UApv+lA6b8pQWm+qUFpv2lAaYBpv6lAaYBpv6lA6b8pQSm/KUFpvulBKb+pQCmAab/pQGm/6UBpv+lAaYApv6lA6b9pQOm/aUDpv2lA6b9pQOm/aUDpv2lAqb/pQCmAab+pQKm/qUBpgCmAKb/pQKm/aUDpv+lAKYApgCm/6UDpvylBKb9pQGmAab9pQSm/KUEpv2lAqb+pQKm/6UBpv6lAqb/pQGm/6X/pQKm/qUCpv+l/6UCpv2lA6b/pQCm/6UBpv+lAqb/pf+lAaYApgCm/6UCpv6lAqb/pQCmAKYApgFa/VkFWvtZA1r+WQJa/lkDWvxZA1r+WQNa/FkEWvxZA1r/Wf9ZAlr+WQFaAFr/WQJa/lkBWgBa/1kCWv5ZAVr/WQFaAFr/WQJa/VkDWv5ZAlr+WQJa/VkEWvxZBFr8WQNa/1n/WQJa/VkEWv1ZAlr+WQGmAKYApgCmAKYApgCmAKYApgCmAKYApgCmAab+pQKm/6X/pQOm/aUCpgCm/qUDpv2lA6b9pQOm/aUDpv2lAqb/pQCmAab/pQCmAab+pQKm/6UBpv+lAKYBpv+lAab/pQGm/6UBpv+lAab/pQGm/6UApgGm/6UBpv+lAaYApv6lA6b9pQOm/qUBpv+lAab/pQKm/aUDpv2lAqYApv+lAab/pQCmAab/pQGm/6UBpv+lAab/pQGmAKb/pQGm/6UCpv2lBKb7pQSm/qUBpgCm/6UApgKm/aUEpvylA6b+pQKm/6UApgCmAKYApgCmAKYApgCm/6UBpv+lAqb+pQCmAab+pQOm/qUBpv+lAab/pQGmAKb/pQKm/qUCpv2lA6b+pQKm/qUBpgCm/6UDpvylA6b/pQCmAKYBpv2lBKb+pf+lA6b8pQOm/6UBpv6lA6b8pQOm/6UApgGm/qUCpv2lBKb8pQOm/6X/pQKm/qUBpgCmAKYApgGm/aUDpv6lAaYBpv6lAaYApv6lA6b+pQGmAKYApv6lA6b9pQOm/6X/pQGm/6UBpgCm/6UBpv+lAqb+pQGm/6UBpgCmAab+pQKm/qUCWv5ZA1r9WQNa/VkCWv9ZAVr/WQJa/VkEWvtZBFr+WQJa/lkCWv5ZAVoAWgBa/1kCWv5ZAVoBWv1ZBFr8WQNa/lkBWgBaAFr/WQFa/1kBWgBa/1kCWv1ZA1r+WQJa/lkCWv1ZBFr8WQRa/FkDWv5ZAlr+pQKm/qUBpgGm/aUEpvylA6b+pQKm/qUCpv6lAqb+pQKm/6UApgGm/qUCpv6lA6b8pQWm+6UEpv6lAab/pQGmAKb/pQKm/qUBpgCm/6UCpv2lBKb7pQWm/KUDpv2lA6b9pQOm/aUCpv+lAab/pQGm/6UApgGm/6UCpv2lBKb8pQKmAab8pQem+KUHpvulA6b/pf+lAqb+pQKm/qUCpv6lAaYApv+lAqb+pQGmAKYApgCmAKb/pQKm/qUDpvylBKb8pQSm/KUEpv2lAqb+pQKm/qUCpv+lAKYApgCmAKYApgGm/qUBpgCm/6UCpv2lBKb8pQSm/KUDpv6lAaYBpv6lAaYApv+lAqb+pQGm/6UBpv+lAab/pQGm/6UApgGm/6UBpv+lAab/pQGm/6UApgKm/KUEpv2lAqYApv6lA6b9pQKmAKb+pQOm/aUBpgGm/qUCpv6lAqb+pQKm/6X/pQOm/aUCpv6lAqb+pQKm/qUBpgCmAKb/pQGmAKb/pQKm/aUDpv6lAaYApv+lAaYApgCm/6UBpv+lAaYApv6lA6b9pQOm/aUCpgCm/6UCpv6lAaYApv+lAqb/pQCmAKb/pQGmAVr+WQJa/lkBWgBaAFoAWgBaAFoAWgBaAFoBWv5ZA1r8WQRa/lkAWgJa/FkFWvtZBVr7WQVa+1kFWvxZAlr/WQBaAlr9WQNa/VkCWgBa/lkDWv1ZAlr/WQBaAVr/WQBaAFoAWgFa/lkDWv1ZAlr+WQJa/qUDpv2lAqb+pQGmAab/pQGm/qUCpv+lAab/pQGm/qUDpv6lAaYApv6lAqYApgCmAKYApv6lA6b+pQKm/qUCpv6lAaYBpv2lA6b+pQGmAKb/pQGmAKYApgCm/6UBpgGm/6UApgCmAKYBpv+lAKYBpv+lAab/pQGm/6UBpgCm/qUEpvqlB6b6pQSm/aUCpv6lAqb+pQKm/qUBpv+lAqb+pQGm/6UBpgCm/6UBpv+lAab/pQGm/6UBpv+lAKYBpv+lAab+pQKm/6UApgGm/qUCpv+lAKYBpv+lAKYCpvylBab8pQKmAKb/pQGmAKYApv+lAqb9pQOm/qUBpgCmAKb/pQGm/6UCpv6lAqb9pQSm/KUEpvylBKb8pQSm/aUCpv+lAab/pQCmAqb9pQKm/6UApgKm/aUBpgGm/aUFpvulA6b/pQCmAKYApgCmAab/pQCmAab+pQOm/qUBpgCm/6UBpgCmAKb/pQKm/aUDpv6lAaYApv+lAKYBpgCmAKb/pQGm/6UBpgCm/6UBpgCm/6UCpv2lA6b+pQKm/qUCpv6lAaYApgCmAKYApv+lAqb+pQGmAab9pQWm+qUFpvylBKb8pQRa/FkDWv5ZAlr+WQFaAFr/WQJa/lkBWgBa/1kCWv5ZAVoAWv9ZAlr+WQFa/1kBWgBaAFr/WQFaAFr/WQJa/lkBWgBa/1kBWgBa/1kBWv9ZAVr/WQFaAFr/WQFa/1kBWgBaAFr/WQFaAFr/WQJa/VkDWv6lAab/pQGm/6UBpv+lAKYBpv+lAab/pQCmAab/pQCmAab+pQOm/aUCpv+l/6UDpvylBab7pQOm/6UApgCmAKYApgCmAKYApv+lAqb/pf+lAab/pQGmAab+pQGm/6UBpv+lAaYApv+lAqb9pQOm/aUDpv6lAqb+pQGm/6UBpgCmAKb/pQGm/6UBpv+lAab/pQGmAKb/pQGm/6UBpgCm/6UCpv2lA6b9pQOm/qUBpgCm/6UBpgCm/6UBpgCm/6UBpv+lAab/pQGm/6UBpv+lAab/pQCmAab+pQOm/KUEpv2lA6b9pQKm/qUDpv2lA6b9pQKm/6UApgCmAab/pQCmAKb/pQOm/KUEpvylA6b/pQCmAKYApv+lAqb/pQCmAKYApgCmAab+pQKm/6UBpv+lAKYBpv+lAab/pQCmAab/pQCmAab+pQOm/qUBpv+lAab/pQGmAKYApv+lAab/pQGmAKYApv+lAab/pQGm/6UCpvylBKb9pQOm/aUCpv6lAqYApv6lAqb+pQGmAab+pQGmAab9pQSm/aUBpgGm/qUCpv+lAKYBpv6lAqb/pQGm/6UBpv+lAqb+pQGm/6UCpv+lAKYAWv9ZAlr/WQBaAFoAWgBaAVr+WQJa/lkBWgBaAVr+WQJa/VkDWv9ZAFoAWgBaAFoBWv5ZA1r8WQVa+1kEWv5ZAFoBWv9ZAVoAWgBa/1kBWgBaAFoAWgBa/1kCWv5ZAlr+WQJa/lkCWv9ZAFoAWgBaAFoApgGm/qUCpv+lAKYApgCmAKYBpv+lAKYApgCmAKYApgCmAKYApgCmAKb/pQGmAKYApgCm/6UBpv+lAqb9pQOm/qUBpv+lAab/pQKm/aUDpv6lAaYApv+lAaYApgCmAKYApgCmAKYApgCmAKYApgCmAKYApgCm/6UCpv6lAaYApv+lAaYBpvylBab8pQOm/qUBpv+lAqb9pQSm/KUDpv6lAaYApgCm/6UCpv6lAqb/pf+lAqb+pQKm/qUCpv2lBKb8pQOm/qUBpgCmAKb/pQKm/qUCpv6lAaYApv+lA6b8pQSm/KUDpv6lAaYApv+lAqb+pQGm/6UBpgCmAKYApv+lAaYApgCmAKYApgCmAKYApgCmAKYApgCmAKYApgCmAKb/pQGmAKb/pQKm/qUApgKm/aUDpv6lAab/pQGm/6UBpv+lAKYCpv2lA6b+pQCmAqb+pQGmAKb/pQGmAKb/pQGmAKb+pQOm/KUFpvylAqb/pQCmAKYBpv+lAKYCpvylBKb9pQKm/6UBpv+lAKYApgCmAab/pQCmAKYApgCmAab+pQKm/qUCpv6lA6b8pQOm/6UApgGm/qUCpv6lAqb/pf+lA6b9WQJa/lkCWv5ZA1r9WQJa/1kAWgFa/1kBWv5ZAlr/WQBaAVr/WQBaAVr+WQJaAFr+WQNa/VkCWgBa/1kBWv9ZAVr+WQNa/lkBWv9ZAFoAWgJa/VkDWv1ZAloAWv5ZBFr7WQVa/FkCWgFa/VkEWvxZA1r/pQCmAKYApv+lA6b8pQSm/KUDpv+lAKYApgGm/qUDpvylBab7pQWm+6UEpv6lAKYBpv6lAqb/pQCmAab+pQKm/6UApgGm/qUDpvylBKb9pQKm/qUBpgCmAKYApgCm/6UDpvylBKb9pQKmAKb/pQCmAqb9pQSm+6UFpvulBqb5pQem+qUFpvylA6b+pQKm/qUBpgCmAab/pQCm/6UCpv6lBKb6pQam+qUFpv6l/6UDpv2lAqb+pQGmAKYBpv+l/6UCpv6lAqb/pf+lAqb/pQCmAab+pQKm/qUDpv2lAaYBpv6lA6b9pQKm/6UBpv+lAab/pQGm/6UCpvylBab7pQSm/qUApgGm/qUCpv+lAKYBpv6lAqb/pQCmAab/pQGm/6UBpv+lAaYApv+lAaYApv+lAqb9pQSm/KUEpv2lAqb/pQCmAKYApgGm/6UApgCm/6UDpvylBKb9pQGmAab+pQKm/6UApgCmAKYApgGm/qUCpv6lAaYBpv6lAqb+pQGmAKYBpv6lAqb+pQKm/6UBpv6lAqb/pQCmAab/pQCmAKYApgGm/qUCpv6lAqb+pQKm/qUCpv+l/6UCpv+lAKYApv+lAlr+WQJa/lkBWgBa/1kBWgBa/1kCWv1ZBFr8WQNa/lkBWgFa/1kAWgBa/1kCWv9ZAFr/WQFa/1kCWv1ZA1r9WQNa/VkCWv9ZAVr/WQFa/lkDWv1ZA1r+WQFaAFr/WQFaAFr/WQFaAFr/WQFa/1kBWv9ZAqb9pQOm/qUBpgCm/6UCpv6lAaYApgCmAKYApgCmAKYApv+lAaYApgCmAKb/pQKm/aUDpv6lAaYBpv6lAaYApv+lAqb/pQCmAKYApgGm/qUDpvylBKb9pQKm/6UApgCmAKYApgGm/qUCpv6lAqb/pQCmAab+pQKm/6UApgCmAab+pQOm/KUDpv+lAKYBpv6lAqb/pQCmAKYApgGm/6UApgCmAKYApgGm/qUCpv+lAKYBpv6lAqb+pQOm/aUDpvylBKb+pQCmAab+pQOm/aUDpv2lA6b9pQOm/aUDpv+l/6UCpv2lA6b/pQCmAKb/pQKm/qUCpv6lAKYCpv6lAaYApv+lAqb9pQOm/aUDpv+l/qUDpv2lA6b+pQGm/6UCpv2lBKb8pQSm+6UFpvylBKb8pQKmAKb/pQGm/6UBpgCm/qUCpv+lAab/pQGm/6UBpv+lAKYBpv+lAab/pQCmAKYApgGm/qUDpvylBKb+pQCmAKYBpv6lAqYApv6lA6b9pQGmAab/pQCmAab+pQKm/6UApgCmAKYApgCmAKYApgCmAKYApgCmAKYBpv6lAqb/pQGm/6UApgCmAab/pQGm/6UApgJa/VkDWv5ZAVoAWv9ZAlr9WQNa/lkBWv9ZAlr9WQNa/lkAWgFaAFr/WQFaAFr/WQFaAFr/WQJa/lkBWgBaAFoAWgBa/1kCWv5ZAlr+WQFaAFoAWgBaAFr/WQJa/lkCWv5ZAVoAWgBaAFr/WQJa/lkCWv6lAqb+pQKm/qUBpgGm/6X/pQOm/KUDpv+lAKYBpv+lAKYApgCmAab/pQCmAKYApgGm/qUCpv6lAqb/pQCmAKYBpv6lAqb/pQCmAab+pQOm/aUDpv2lAqb/pQGm/6UBpv+lAab/pQCmAab/pQKm/KUFpvulBab8pQOm/qUBpgCm/6UCpv6lAqb+pQKm/aUDpv+lAKYApgCm/6UCpv6lAqb+pQKm/qUCpv6lAqb+pQKm/6UApgCm/6UDpvylBab6pQWm/aUCpv6lAqb/pQCmAKYApv+lA6b8pQSm/KUDpv6lAqb+pQGmAKYApgCmAKb/pQOm/KUEpvylBKb9pQGmAab+pQKm/qUCpv+lAKYApgCmAKYBpv+lAKYApgGm/qUCpv+lAKYBpv+lAKYBpv+lAKYBpv6lA6b9pQKm/6UApgGm/6UApgGm/6UBpgCm/6UBpgCm/6UCpv6lAaYApv+lAab/pQGmAKb/pQCmAab/pQGm/6UBpv+lAaYApv6lBKb8pQOm/6X/pQGmAKb/pQKm/qUApgKm/aUDpv2lA6b9pQOm/qUBpgCm/6UBpv+lAqb+pQGmAKb/pQKm/qUBpgCm/6UBWgBaAFoAWv9ZAVoAWgBaAFoAWv9ZAlr+WQJa/lkBWgBaAFoAWgBaAFoBWv5ZAlr+WQNa/VkCWv9ZAFoBWv9ZAFoBWv9ZAFoBWv5ZAloAWv5ZA1r8WQNa/1kAWgFa/lkCWv5ZAlr+WQJa/1kAWgFa/lkCpv+lAab+pQOm/aUCpgCm/qUCpgCm/qUDpv2lAqb/pQGm/qUCpv+lAKYBpv6lAqb+pQKm/6UApgCmAab+pQOm/KUDpv+lAKYBpv6lAaYApgGm/qUCpv6lAaYApgCmAKYApgCm/6UBpgCmAKYApgCm/6UCpv6lAqb+pQKm/qUCpv6lA6b9pQKm/6UApgKm/qUBpgCm/6UCpv6lAqb+pQGmAKYApgCmAKb/pQKm/qUCpv6lAqb+pQKm/qUBpgCmAKb/pQGmAKb/pQKm/aUDpv6lAqb9pQOm/qUBpgCm/6UBpv+lAaYApgCmAKb/pQGmAKYApgCmAKYApgCmAKYApgCmAKYApgCmAab9pQOm/aUEpvylBKb7pQSm/6X/pQOm+6UEpv6lAaYApv+lAaYApgCm/6UCpv2lBKb9pQKm/qUCpv6lAqb+pQKm/6UApgGm/qUCpgCm/qUDpv2lAqYApv+lAKYCpv2lA6b+pQCmAab/pQGm/6UApgGm/6UApgCmAab+pQSm+qUGpvulBKb9pQKm/6UApgGm/6UApgGm/6UBpv+lAKYApgGm/6UBpv6lAqb/pQGm/6UApgGm/6UBpv+lAFoBWv5ZA1r8WQRa/VkBWgFa/lkCWv9ZAVr+WQJa/lkCWv9ZAFoAWv9ZAlr+WQFaAFr/WQJa/lkBWgBa/1kCWv5ZAVoBWv1ZBFr8WQRa/VkCWv5ZAlr+WQJa/1kAWgFa/1kAWgFa/lkDWv1ZAlr/WQBaAab+pQKm/6UApgGm/6UBpgCm/6UBpv+lAab/pQKm/qUApgGm/6UBpgCm/6UBpv+lAKYBpv+lAqb9pQKm/qUCpgCm/6UBpv6lAqb/pQGm/6UBpv6lA6b9pQOm/aUDpv2lBKb8pQOm/qUBpgCmAKYApgCm/6UBpgCmAKb/pQGm/6UBpgCm/6UApgKm/qUBpgCm/6UCpv6lAaYApv+lAqb+pQGmAKb/pQGmAKYApgCm/6UBpgCmAKYApv+lAqb+pQKm/6X/pQKm/qUBpgKm/KUDpv6lAaYBpv+l/6UBpgGm/qUCpv6lAaYBpv6lAqb+pQKm/qUCpv+lAKYApgCmAab/pQGm/6UApgGm/6UBpv+lAab/pQCmAab/pQGm/6UBpv+lAqb9pQOm/aUDpv+l/6UCpv6lAaYApv+lAqb/pf+lAqb+pQGmAKYApgCmAab+pQKm/6UApgGm/qUDpv2lAaYApgCmAKYBpv2lA6b9pQSm/aUBpgCm/6UCpv2lBKb8pQSm/aUBpgCmAKYApgCmAKYApgCmAKb/pQKm/qUBpgCm/6UCpv6lAaYApgCmAKb/pQKm/qUDpvylA6b/pQCmAab+pQKm/1kAWgFa/lkDWv1ZAlr/WQBaAVr/WQBaAVr+WQNa/VkCWv9ZAVr/WQFa/1kAWgJa/VkCWv9ZAFoBWv9ZAFoAWgBaAVr+WQNa/FkEWv1ZAlr+WQNa/VkCWv9ZAFoBWv9ZAVr/WQFa/1kAWgFaAFr/WQFa/qUCpgCm/6UBpv+lAKYBpv+lAKYBpv+lAKYBpv6lAaYBpv6lAqb+pQGmAKb/pQKm/aUDpv2lA6b9pQOm/aUDpv2lA6b9pQSm+6UFpvylA6b+pQGmAKb/pQKm/aUDpv6lAqb+pQKm/aUDpv+lAKYBpv6lAqb+pQGmAab+pQOm/KUDpv6lA6b8pQSm/aUBpgKm/KUDpv+lAKYBpv6lAqb+pQOm/aUDpvylBKb+pQGm/6UApgGm/6UBpv+lAaYApv+lAKYApgKm/qUCpvylBKb+pQGmAKb/pQGmAKYApv+lAqb+pQKm/6X/pQKm/6UApgGm/aUFpvulBKb+pf+lA6b8pQSm/qUApgGm/qUCpv+lAKYApgCmAKYApgCmAKb/pQKm/qUCpv2lBKb8pQOm/6UApgCmAab9pQSm/aUCpv6lAqb+pQKm/qUCpv6lAqb+pQKm/qUDpvylBKb9pQKm/6UApgCmAKYBpv6lAqb+pQKm/qUCpv6lAqb+pQKm/qUCpv+lAKYApgGm/6UBpv+lAKYBpv+lAab/pQCmAKYApgCmAab9pQOm/qUCpv+l/6UBpgCmAKYApgCm/6UCpv2lBKb8pQNa/lkBWgBaAFoAWgBaAFoBWv5ZAlr+WQNa/VkDWvxZBFr9WQNa/lkAWgBaAVr+WQNa/FkEWv1ZAlr+WQFaAVr+WQJa/lkBWgFa/lkCWv1ZA1r+WQFaAVr+WQFaAFr/WQJa/lkCWv5ZAlr/WQBaAFoAWgCmAab/pf+lAqb+pQOm/aUCpv6lA6b9pQOm/aUCpgCm/6UBpv+lAKYBpv+lAab/pQGm/6UApgKm/aUEpvulBab8pQKmAab9pQSm+6UFpvulBab8pQKm/6UApgCmAab+pQKm/qUCpv6lAaYApv+lA6b7pQWm+6UEpv+l/6UBpgCm/qUDpv6lAaYApv+lAaYApv+lAab/pQGm/6UBpv6lA6b9pQKm/qUCpv6lAqb/pf+lA6b8pQSm/KUEpv2lAqb/pQCmAKYBpv+lAab+pQKm/6UBpv+lAKYBpv6lA6b8pQSm/qUApgGm/qUCpv+lAab/pQCmAKYBpv6lA6b9pQKm/6UApgGm/6UBpv6lAqYApv+lAab/pQCmAab/pQGm/6UBpv+lAab+pQOm/KUFpvulBKb+pQCmAab/pQCmAqb9pQOm/aUCpgCm/6UBpv+lAKYBpv+lAab/pQGm/6UBpv+lAab+pQKmAKb/pQGm/6UApgGm/6UBpv+lAab/pQCmAKYBpv+lAKYBpv6lAqb/pf+lA6b8pQSm/aUBpgCmAKYApgCmAKb/pQOm/KUEpvylA6b+pQKm/qUCpv6lAaYApgCm/6UCWv1ZA1r+WQFaAFr/WQJa/VkDWv5ZAVoBWv1ZA1r+WQFaAFr/WQJa/VkEWvxZBFr8WQNa/lkCWv5ZAlr+WQJa/lkCWv5ZAlr+WQJa/lkCWv5ZAlr/WQBaAFoAWgBaAFoAWgFa/VkEWvtZBVr9WQFa/1kBpv+lAqb9pQOm/aUDpv6lAKYCpv2lA6b+pQGm/6UBpv+lAqb+pQGm/6UBpgCmAKYApgCm/6UBpgCmAKYBpv2lA6b+pQKm/6UApgCmAKYBpv+lAab/pQGmAKb/pQKm/qUBpgGm/aUFpvqlBab9pQGmAab+pQKm/6UApv+lAqb+pQKm/qUBpgCm/6UBpv+lAab/pQGm/6UApgGm/qUCpv+lAKYBpv+lAKYBpv+lAab/pQGm/6UBpgCm/6UBpv+lAqb9pQSm+6UFpv2lAaYApv+lAqb+pQKm/qUBpgCmAKb/pQKm/aUDpv6lAaYApv+lAab/pQGmAKYApv6lA6b9pQKmAab8pQWm/KUDpv2lBKb7pQWm/KUCpgCm/6UBpv+lAaYApv+lAaYApv+lAqb9pQOm/qUBpv+lAab+pQOm/aUDpv2lA6b9pQOm/aUDpv2lA6b+pQCmAqb9pQOm/aUDpv6lAaYApv6lA6b9pQKm/6UBpv6lA6b8pQSm/qUBpv+lAqb9pQSm/KUDpv6lAqb+pQKm/qUCpv6lAqb+pQGmAab+pQKm/qUCpv6lAqb+pQGmAKb/pQGmAKb+pQOm/aUCpv+lAVr+WQNa/lkAWgFa/1kBWgBa/1kBWv9ZAVr/WQFa/1kBWv5ZAlr/WQBaAVr+WQJa/1kAWgBaAVr+WQJa/lkCWv5ZA1r8WQRa/FkDWv9ZAFoAWgFa/VkEWvxZBFr9WQJa/lkCWv5ZAlr+WQFaAFr/WQJa/qUBpgCm/6UBpgCm/6UCpv2lBKb8pQOm/qUApgKm/qUBpgCmAKb/pQKm/aUDpv6lAqb9pQOm/qUBpgCmAKb+pQSm/KUDpv6lAab/pQGmAKb/pQKm/aUDpv2lA6b+pQGmAKb/pQGm/6UCpv2lA6b+pQGm/6UBpv6lA6b+pQCmAab+pQOm/aUDpv6lAab/pQGm/6UCpv2lA6b9pQKm/6UApgGm/qUCpv6lAqb/pQCmAab/pQCmAab/pQGmAKb/pQGm/6UBpv+lAab/pQGm/6UBpv+lAKYBpv+lAKYBpv6lAqYApv6lAqb/pQCmAab/pQCmAaYApv+lAab/pQGm/6UBpv+lAaYApv+lAab+pQOm/aUCpv+lAab/pQGm/qUCpgCm/6UBpv+lAKYBpv6lA6b9pQKm/6X/pQOm/aUCpv+lAKYApgCmAab+pQKm/qUBpgCmAKYApgCm/6UCpv2lBKb8pQOm/qUCpv6lAqb+pQGmAKYApgGm/qUBpgCmAKYApgCmAKYApgCmAKYApgCmAab+pQKm/6UApgGm/6UBpv6lA6b8pQSm/aUCpv+lAKYApgCmAKYApgGm/qUCpv6lAqb+pQFaAFr/WQJa/lkBWgBa/1kCWv5ZAlr+WQJa/lkCWv1ZA1r+WQFa/1kCWv1ZA1r9WQNa/lkBWgBa/1kCWv5ZAVoAWgBa/1kCWv5ZAlr+WQJa/VkEWvxZA1r/WQBaAFoAWgBaAFoBWv5ZAlr/WQBaAFoAWgCmAKYBpv6lAqb+pQKm/6UApgGm/qUCpv+l/6UCpv+lAKYApv+lAqb9pQSm+6UFpvylAqb/pQKm/aUDpv2lA6b+pQGm/6UBpgCmAKb/pQGm/6UBpgGm/aUDpv2lA6b+pQGm/6UBpv+lAab+pQOm/aUDpv2lAqb+pQOm/qUApgGm/qUDpv2lAqb/pQGm/qUDpvylBKb+pQCmAab/pQCmAab/pQCmAKYBpv+lAab+pQGmAab/pQCmAKb/pQKm/qUCpv6lAaYApv+lA6b8pQSm/KUDpv6lAab/pQKm/aUCpv+lAKYCpv2lAqb+pQOm/qUBpv+lAKYBpgCm/6UCpv2lA6b9pQOm/qUBpgCm/6UBpgCmAKYApv+lAaYApgCmAKb/pQGm/6UCpv6lAab/pQGmAKb/pQKm/aUDpv6lAKYBpgCm/6UCpv2lA6b+pQKm/qUCpv6lAqb/pQCmAKYApgCmAab/pQCmAKYApgCmAab/pQCmAab/pQCmAab/pQGm/6UApgCmAKYBpv6lAqb+pQKm/qUDpvylBKb8pQOm/6UApgCmAKb/pQKm/qUDpvylBKb8pQOm/6UApgGm/qUBpgCm/6UCpv9ZAFoAWv9ZAVoAWgBaAFr/WQFaAFoAWgBa/1kCWv5ZAlr/WQBaAFoAWv9ZAVoBWv1ZBFr8WQJaAFoAWv9ZAlr9WQRa/VkBWgBa/1kBWgBaAFoAWgBa/1kCWv5ZAVoAWv9ZAlr+WQFaAFr/WQJa/lkCWv6lAqb/pQCmAKYApgCmAab+pQKm/qUBpgGm/qUCpv2lA6b+pQGmAKb/pQGmAKb/pQKm/qUBpgCm/6UCpv6lAaYApv+lAab/pQKm/qUBpgCm/6UBpgCmAKb/pQKm/aUEpv2lAaYApv+lA6b8pQSm/aUBpgCmAKYApgCmAKb/pQKm/qUBpgCm/6UBpgCm/qUDpv6lAKYBpv6lAqb/pQCmAab+pQKm/qUCpv+lAab+pQKm/qUCpv+lAKYApgCmAKYApgCmAKYApgCmAKYApgCmAKYApgCmAKYApgCmAKYApv+lAqb+pQKm/aUEpvylA6b+pQGm/6UCpv6lAab/pQGm/6UBpv+lAKYBpgCm/6UBpv6lA6b+pQKm/aUCpgCm/6UBpv+lAKYBpv6lA6b8pQSm/KUEpvylBKb8pQSm/aUBpgGm/qUCpv+lAKYBpv+lAKYBpv6lA6b9pQOm/aUCpv6lAqb/pQCmAab+pQKm/qUCpv+lAKYBpv6lAaYBpv+lAab/pQCmAKYBpv+lAab+pQKm/qUCpv+lAKYBpv+lAKYBpv+lAaYApv+lAab/pQGmAKb/pQGm/6UBpv+lAab/pQGm/6UAWgFa/lkCWv9ZAFoBWv5ZAlr+WQFaAFoAWgBaAFr/WQFa/1kBWgBa/1kCWv1ZA1r+WQFaAFr/WQFaAFr/WQJa/VkCWgBa/1kBWv9ZAFoBWv9ZAVr/WQFa/lkDWv1ZA1r+WQFaAFoAWv9ZAVoAWgBaAVr+pQGmAKYApgGm/qUCpv6lAqb+pQKm/aUEpvylBKb8pQOm/aUEpvylBKb7pQWm/KUEpvylA6b+pQGmAKYApv+lAaYApv+lAqb+pQCmAqb9pQOm/qUBpgCm/6UCpv2lA6b+pQGmAKb/pQKm/aUEpvulBab8pQOm/6X/pQKm/qUCpv+lAKYApgCmAKYApgGm/qUCpv6lAqb+pQKm/qUCpv6lAqb+pQGmAKYApgCmAKYApgCmAab+pQKm/6UBpv6lA6b8pQSm/aUCpv+l/6UCpv6lAqb/pf+lAqb+pQKm/6X/pQOm/KUEpv2lAqb/pQCmAab+pQOm/aUDpv6lAKYBpv+lAqb+pQGmAKb+pQSm+6UEpv+l/qUDpv2lAqb/pQGmAKb/pQGm/6UBpgCm/6UBpgCm/6UCpv2lA6b+pQCmAqb9pQOm/aUCpv+lAKYBpv6lAqb+pQKm/6UBpv6lAqb+pQKm/6UApgGm/qUBpgCmAKYApgCmAKYApgCmAKb/pQOm/KUDpv+l/6UCpv6lAKYCpv6lAqb+pQCmAaYApv+lAqb9pQSm/KUDpv2lA6b+pQGmAKb/pQKm/aUDpv6lAaYApgCmAFoAWv9ZAVoAWgFa/VkEWvtZBlr7WQNa/lkCWv5ZAlr9WQRa/FkEWvxZA1r9WQRa/VkCWv5ZAFoCWv5ZAlr+WQFa/1kCWv5ZAVoAWv9ZAVoAWv9ZAVr/WQBaAlr9WQJaAFr/WQJa/VkDWv5ZAlr+WQFa/6UBpgCm/6UCpv2lA6b9pQOm/aUDpv6lAKYBpv+lAaYApv6lA6b9pQOm/qUBpv+lAqb9pQOm/qUBpgCmAKYApv+lAab/pQKm/qUCpv2lA6b+pQKm/6UApgGm/6UApgGm/6UBpgCm/6UApgGm/6UBpv+lAab+pQKm/qUCpv+lAKb/pQGmAKYApgCmAKb/pQKm/qUCpv+l/6UCpv6lAqb+pQGmAKb/pQOm+6UEpv6lAKYCpv2lAqb/pQGm/6UBpv6lA6b9pQOm/aUCpv+lAab/pQCmAab+pQKm/qUCpv+lAKYApgCmAKYApgCmAab/pQGm/qUCpv6lA6b9pQOm/KUDpv6lAqb/pQCmAKYApgCmAKYApgCmAab+pQKm/qUCpv+lAKYApgCmAKYApgCm/6UCpv2lA6b+pQCmAqb9pQOm/qUApgGmAKb/pQKm/qUBpv+lAqb+pQKm/qUApgGmAKb/pQGm/6UApgGm/6UApgKm/aUDpv6lAKYBpv+lAqb+pQGm/6UBpv+lAab/pQGm/6UBpv+lAab/pQGm/6UCpv2lA6b+pQGmAKb/pQGm/6UBpv+lAab/pQCmAab/pQGm/qUCpv9ZAVr/WQFa/1kBWv9ZAVr/WQFa/1kCWv1ZAlr/WQFaAFr/WQBaAVr/WQFa/lkCWv5ZA1r8WQRa/FkDWv9Z/1kDWvxZBFr8WQRa/VkCWv9ZAFoAWgFa/1kAWgFa/lkCWv9ZAFoAWgBaAFoAWgBaAFoAWgCmAKYApgCmAKYApgCmAKYApgCm/6UCpv6lAqb/pf+lAaYBpv6lA6b8pQOm/6X/pQOm/KUEpvylA6b+pQGmAKb/pQGm/6UBpv+lAKYBpv+lAab/pQCmAaYApv+lAab/pQCmAab/pQGm/6UApgCmAab/pQGm/qUCpv+lAab/pQCmAKYApgCmAab/pQCmAab/pQCmAab/pQGmAKb/pQGm/6UBpv+lAab/pQGm/6UBpv+lAab/pQGmAKb/pQGmAKb/pQGm/6UBpv+lAab/pQCmAab/pQGm/6UApgGm/6UBpgCm/qUEpvulBab8pQOm/qUBpgCmAKb/pQKm/qUBpgCm/6UCpv6lAab/pQGmAKb/pQGm/6UBpv+lAab/pQGm/6UBpv+lAaYApv6lBKb8pQOm/qUBpgCmAKYApv+lAqb+pQGmAKYApv+lAqb9pQOm/qUBpgCm/6UCpv2lA6b+pQGmAKb/pQKm/aUEpvulBqb6pQWm/KUDpv6lAqb9pQSm/KUDpv+l/6UCpv6lAaYApgCmAKYApgCmAKYApgCmAab+pQOm/aUBpgKm/aUDpv2lAqYApgCm/6UCpv2lBKb8pQOm/6X/WQJa/lkCWv9ZAFoAWgBaAVr+WQJa/1n/WQJa/lkCWv1ZBFr7WQVa/FkCWgBa/1kBWv9ZAVoAWv9ZAFoBWv9ZAVr/WQBaAVr+WQNa/FkEWv1ZAlr/WQBaAVr/WQBaAVr/WQFa/1kBWv9ZAVr+WQJa/1kBpv+l/6UCpv+lAKYBpv6lAqb/pQCmAKYBpv+lAKYBpv6lA6b9pQKm/qUDpv2lAqb+pQKm/6UApgGm/qUCpv+lAab/pQGm/qUCpv+lAaYApv6lAqb/pQCmAab+pQKm/qUCpv6lAqb+pQKm/qUCpv+lAKYBpv6lA6b9pQOm/aUDpv2lAqb/pQGmAKb+pQOm/aUDpv6lAKYBpv+lAqb9pQOm/aUCpgCm/6UBpv+lAab/pQGm/6UBpv+lAab/pQCmAqb9pQOm/qUApgKm/aUDpv6lAab/pQGmAKYApgCm/6UCpv6lAqb+pQGmAKb/pQKm/aUEpvulBab8pQOm/qUBpv+lAqb9pQOm/aUCpv+lAaYApv+lAKYApgGm/6UBpv+lAab/pQCmAab/pQKm/aUCpv+lAqb9pQOm/aUCpv+lAab/pQGm/qUCpv+lAaYApv6lAqYApv+lAab/pQGm/6UBpv+lAab/pQKm/aUEpvulBKb+pQGmAKYApv6lBKb8pQOm/qUBpgCm/6UCpv2lA6b9pQKm/6UBpv+lAKYBpv6lA6b9pQKmAKb9pQWm+6UEpv6lAKYBpv+lAKYCpv2lA6b9pQKm/1kBWv9ZAVr+WQNa/FkFWvtZBFr9WQJa/1kAWgBaAFoAWgBaAVr9WQVa+lkGWvtZA1r/WQBaAVr+WQJa/lkCWv9Z/1kCWv5ZAlr+WQFaAFr/WQJa/lkBWgBa/1kBWgBa/1kCWv1ZAlr/WQBaAVoAWv5ZAqb/pQCmAqb9pQOm/aUDpv2lAqYApv+lAab/pQCmAab/pQGmAKb/pQGm/6UApgGm/6UApgGm/qUDpv2lAqb/pQGm/6UCpv2lA6b+pQGm/6UBpgCm/qUDpv2lAqYApv6lA6b8pQSm/aUDpv6lAKYApgGm/qUDpv2lA6b9pQKm/6UBpv+lAab+pQOm/aUCpgCm/qUCpv6lA6f9pgOn/aYBpwKn/aYDp/2mAqf/pgGn/6YBp/6mAqf/pgCnAaf+pgKn/qYCp/+m/6YDp/ymA6f/pv+mAqf+pgGnAKcAp/+mAqf9pgOn/qYBp/+mAaf/pgGn/6YApwCnAaf/pgCnAaf+pgOn/aYCp/+mAKcBp/6mA6f8pgSn/KYDp/6mAacAp/+mAqf9pgKn/6YBpwCn/6YBp/6mA6f9pgSn+6YFp/umBaf8pgOn/aYDp/6mAacAp/+mAqf+pgGnAKf/pgKn/qYCp/6mAKcCp/2mBKf9pgGnAKf/pgGnAaf/pv+mAqf9pgSn/aYBpwGn/aYEp/2mAqf+pgKn/qYCp/+mAKcApwCnAKcApwCnAaf+pgKn/6YApwGn/qYCp/6mAqf/pv+mAqf/pv+mA1n8WANZAFn9WARZ/VgCWf5YAln9WARZ/FgDWf9YAFkAWf9YAVkAWQBZAFn/WAJZ/lgAWQJZ/VgDWf5YAVkAWQBZ/1gBWQBZAFkAWQFZ/VgFWfpYBln8WAFZAVn+WANZ/lj/WAJZ/lgCWf9Y/1gCWf5YAqf+pgKn/qYCp/+mAKcBp/+mAaf/pgCnAaf/pgKn/aYCpwCn/qYEp/umBaf8pgOn/qYCp/+mAKf/pgOn/aYDp/ymBKf9pgOn/aYBpwGn/6YBp/+mAaf/pgGn/6YBpwCn/6YCp/2mA6f9pgOn/qYBpwCn/6YCp/2mA6f9pgSn+6YGp/mmBqf8pgKnAKf/pgCnAaf/pgGnAKf+pgOn/aYCpwCn/6YBp/+mAKcBp/+mAaf/pgCnAaf+pgOn/KYEp/ymA6f/pgCnAaf+pgGnAaf+pgOn/aYCp/+mAKcApwGn/qYDp/2mAqf+pgKn/qYDp/ymBKf8pgOn/6b/pgOn+6YGp/qmBaf9pgCnA6f8pgOn/qYBpwCnAKcApwCnAKcAp/+mAqf+pgGnAKf/pgKn/aYDp/6mAacBp/6mAqf+pgKn/6YApwGn/qYCp/6mAqf/pgCnAKcAp/+mA6f9pgKn/qYBp/+mAqf/pv+mAqf8pgan+aYGp/ymAqcBp/ymBKf9pgOn/aYCp/+mAaf/pgGn/qYDp/2mAqf+pgOn/aYDp/ymA6f/pgCnAKcApwCnAaf+pgKn/qYDp/2mAqf/pgGnAKcAp/9YAVkAWf9YAln9WARZ+1gGWfpYBFn/WP5YBFn8WANZ/lgBWQBZ/1gBWQBZ/1gBWQBZ/1gBWf9YAVkAWQBZ/1gBWf9YAln9WANZ/lgBWQBZ/1gBWQBZAFn/WAFZ/1gBWQBZ/1gCWfxYBVn8WANZ/1j/WAKn/qYCp/6mAacBp/6mAqf+pgKn/6YApwCnAKcBp/6mAqf+pgKn/qYCp/6mAqf+pgGn/6YDp/ymA6f+pgCnA6f9pgCnAqf+pgKn/6b/pgKn/qYBpwGn/qYCp/6mAacApwCn/6YBpwCnAKf/pgGn/6YApwOn+6YEp/6mAKcCp/2mAqf/pgGn/6YApwGn/qYCp/+mAKcBp/6mAacApwCnAKcAp/+mAacApwCnAKf/pgGnAKf/pgKn/aYEp/ymA6f9pgOn/6YApwCn/6YBpwCnAKcApwCn/6YBpwCnAKf/pgGn/6YBpwCn/6YBpwCn/6YCp/2mA6f+pgGnAKcAp/+mAaf/pgGn/6YBp/+mAaf/pgGn/6YApwKn/aYDp/2mAqcApwCn/6YBp/+mAaf/pgGn/6YBp/+mAKcBp/6mA6f9pgOn/qYApwGnAKf/pgKn/aYDp/6mAqf+pgGn/6YBpwCnAKcAp/+mAaf/pgKn/qYBpwCn/qYEp/ymA6f+pgGn/6YBpwCn/6YBpwCn/6YCp/6mAacApwGn/6YApwGn/6YBp/+mAaf/pgGn/6YBp/+mAaf/pgCnAqf9pgOn/aYCpwCn/6YAWQFZ/lgDWf1YAln/WAFZ/lgDWf1YA1n+WABZAVkAWf9YAVn/WAFZAFkAWf9YAln9WARZ/FgDWf5YAln+WAJZ/lgBWQBZAVn9WARZ/FgDWf9Y/1gCWf5YAVkBWf5YAln+WAFZAFkAWQBZ/1gBWQBZ/1gCp/2mAqcAp/+mAqf9pgSn/KYDp/6mAacApwCnAKf/pgKn/aYEp/ymA6f+pgGnAKcApwCn/6YBp/+mAacAp/+mAacAp/+mAqf+pgGnAaf+pgKn/6YApwGn/qYCp/6mA6f8pgSn/aYBpwGn/aYEp/ymBKf8pgOn/qYCp/2mBKf8pgSn/aYCp/6mA6f9pgKn/6YApwGn/6YApwGn/qYDp/ymBKf9pgKn/6YApwGn/qYDp/2mAqcAp/6mA6f8pgSn/aYCp/+m/6YCp/6mAqf+pgKn/qYDp/2mAacApwCnAaf+pgOn+6YGp/qmBaf9pgKn/qYBp/+mAacApwCnAKf/pgGn/6YCp/6mAqf9pgSn/KYDp/6mAacApwGn/aYEp/ymBKf9pgGnAaf/pgGn/6YApwGn/6YBp/+mAaf/pgCnAKcBpwCn/6YApwGn/6YBp/+mAaf/pgGn/qYCp/+mAaf/pgGn/qYCp/6mAqcAp/6mA6f8pgOn/qYBpwCnAaf+pgGn/6YBp/+mAqf9pgOn/aYCp/+mAaf/pgGn/6YApwKn/aYDp/6mAKcBp/+mAacAp/+mAaf/pgKn/aYEp/ymA6f+pgGn/1gCWf1YA1n+WAFZAFn/WAFZAFn/WAFZAFn/WAJZ/VgDWf5YAVkBWf1YBFn8WANZ/lgCWf5YAln+WAFZAFkAWQFZ/lgCWf5YAVkBWf5YAVkAWQBZAFkAWQBZAFkBWf9YAFkAWQBZAFkBWf9Y/1gCWf5YAqf/pv+mA6f8pgSn/KYEp/2mAqf+pgKn/qYCp/6mAqf/pgCnAKcApwCnAaf/pgGn/6YApwGn/6YBpwCn/qYDp/2mA6f+pgCnAqf+pgGnAKf/pgKn/qYCp/6mAacApwCn/6YDp/umBqf6pgSn/6b/pgOn+6YEp/6mAacBp/6mAKcCp/2mBKf8pgOn/qYBpwCnAKcApwCnAKcApwGn/qYCp/+mAaf+pgOn/KYEp/2mAqf+pgOn/KYEp/2mAqf+pgKn/qYDp/2mAqf9pgSn/aYCp/+mAKcBp/6mA6f9pgOn/aYDp/2mA6f+pgGn/6YApwCnAKcBp/6mAqf9pgOn/qYBpwCn/6YBpwCnAKf/pgGnAKf/pgKn/qYApwKn/aYDp/2mAqf/pgCnAaf+pgKn/qYCp/+mAKcApwGn/qYDp/ymBKf9pgKn/6b/pgKn/qYCp/6mAacAp/+mAaf/pgGnAKcAp/+mAaf/pgKn/qYCp/6mAqf+pgKn/aYEp/ymBKf8pgSn/KYDp/6mAacBp/6mAaf/pgGnAKcAp/+mAqf9pgOn/qYCp/6mAqf+pgKn/6YApwCnAKcApwGn/qYCp/6mAqf+pgJZ/lgCWf5YAln+WAJZ/lgBWQBZAFkAWQBZAFkAWQBZ/1gDWfxYBFn9WAFZAVn+WAFZAFn/WANZ+1gFWfxYAlkAWf9YAVkAWf9YAVkAWf9YAln+WAFZAFkAWQBZ/1gBWf9YAln9WANZ/VgDWf5YAVn/WAGnAKcApwCnAKcApwCnAKcBp/6mA6f8pgSn/aYDp/2mAqf+pgOn/aYCp/+mAKcApwCnAKcApwCn/6YCp/6mAqf9pgOn/aYEp/ymAqcAp/+mAacAp/+mAqf+pgKn/qYCp/+mAKcBp/6mAqf/pgCnAKcBp/6mAqf+pgKn/6YApwGn/qYCp/+m/6YDp/ymBKf8pgOn/6YApwCnAKcApwGn/qYDp/2mA6f9pgOn/aYDp/2mAqcAp/+mAaf/pgCnAqf9pgOn/qYBpwCn/6YCp/2mBKf8pgOn/qYBpwCnAKcAp/+mAqf+pgKn/qYCp/6mAqf/pgCnAKcBp/6mA6f9pgKn/6YApwGn/qYCp/6mAqf+pgKn/qYCp/6mAqf/pgCnAaf+pgOn/aYDp/2mAqf/pgGn/6YBp/+mAKcApwGn/qYDp/ymA6f/pgCnAKf/pgKn/aYEp/ymA6f/pv+mAqf9pgSn/KYEp/2mAaf/pgKn/qYCp/6mAacApwGn/aYEp/ymBKf8pgOn/qYBpwCn/6YBpwCn/6YBpwCnAKf/pgKn/qYBpwGn/qYCp/+m/6YCp/+mAKcBp/6mAqf/pgCnAaf+pgKn/6YApwBZAFkAWQBZAVn9WARZ/FgEWfxYBFn9WAFZAFkAWQBZAVn+WAFZAFkBWf1YBFn8WANZ/1j/WAJZ/lgCWf5YAln+WAJZ/lgCWf5YAln+WAFZAFkAWf9YAln9WANZ/lgAWQJZ/VgCWQBZ/lgDWf1YAlkAWf+mAKcBp/+mAacAp/6mA6f+pgGnAKf/pgGnAKcAp/+mAacAp/+mAqf9pgKnAKf+pgOn/aYDp/2mAqf+pgKn/6YApwGn/qYCp/6mAacBp/6mAqf/pgCnAaf+pgGnAKcApwGn/qYCp/2mA6f+pgKn/qYBpwCn/6YCp/6mAKcCp/2mBKf8pgOn/qYBpwGn/aYEp/ymA6f/pv+mAqf+pgGnAKcApwGn/6YApwGn/6YBp/+mAacAp/+mAaf+pgSn+6YFp/umBKf9pgKn/qYDp/ymBKf8pgOn/6YApwCnAKcApwGn/qYCp/+mAKcBp/6mAqf+pgOn/KYEp/ymA6f/pgCnAKcAp/+mAqf/pgCnAKf/pgGnAKcAp/+mAqf9pgOn/qYBp/+mAqf9pgSn/KYDp/6mAacApwCnAKcApwCnAKcApwCnAKcApwCnAKcApwCnAKf/pgGn/6YCp/6mAaf/pgGn/6YCp/2mA6f+pgGnAKf/pgGnAKf/pgOn/KYDp/6mAacApwCn/6YBpwCn/6YBp/+mAacApwCnAKcApwCn/6YCp/6mAqf/pv+mAqf+pgGnAKcApwCnAKcAp/+mAacAp/+mAqf9WANZ/lgBWQBZ/1gBWf9YAln+WAFZ/1gBWf9YAln+WAFZ/1gBWQBZ/1gBWQBZ/1gCWf1YA1n+WAFZAFkAWQBZ/1gCWf5YAln+WAFZAFn/WAJZ/VgDWf5YAVkAWf9YAln9WAVZ+lgGWfpYBVn9WAJZ/lgBp/+mAqf/pgCnAKf/pgKn/qYCp/6mAqf+pgGn/6YCp/6mAacAp/+mAqf+pgGnAKf/pgKn/qYCp/6mAacApwCnAKcApwGn/aYEp/ymA6f+pgKn/aYEp/ymA6f/pv+mA6f7pgan+6YEp/2mAacApwCnAKcBp/6mAqf+pgKn/qYDp/2mAacBp/2mBKf9pgKn/qYCp/6mAacApwCnAKcApwCn/6YCp/6mAacAp/+mAaf/pgGn/6YBp/6mA6f+pgCnAqf9pgOn/qYBpwCn/6YCp/6mAacAp/+mAqf+pgGn/6YBpwCn/6YBp/+mAaf/pgCnAaf/pgGn/6b/pgKn/6YApwGn/qYBpwGn/qYCp/+mAKcApwCnAaf+pgOn/KYEp/2mAacBp/6mAqf+pgKn/qYCp/6mAqf+pgGnAKf/pgKn/qYBp/+mAKcBpwCn/6YBp/+mAacAp/+mAacApwCnAKf/pgKn/qYCp/6mAqf+pgKn/qYCp/+mAKcApwCnAKcApwCnAKcApwCn/6YBpwGn/aYEp/ymA6f+pgGn/6YCp/6mAaf/pgGn/6YBpwCn/6YBp/+mAaf/pgKn/qYBp/+mAaf/pgGn/1gBWf9YAVn9WAVZ/FgCWQBZ/lgDWf5YAVkAWf9YAln+WAJZ/lgBWQFZ/lgDWfxYA1n/WABZAFkAWQBZAFkAWQBZ/1gCWf5YAVkAWf9YAln+WAFZAFn/WAFZAFkAWf9YAln9WANZ/lgBWQBZAFn/WAFZAKf/pgOn/KYDp/6mAacApwGn/6b/pgKn/aYEp/2mAacBp/6mAacAp/+mA6f9pgKn/qYCp/+mAaf/pgGnAKf/pgKn/aYDp/6mAqf+pgGn/6YBpwCnAKcAp/+mAqf+pgKn/qYCp/6mA6f9pgGnAaf/pgGnAKf/pgCnAqf9pgOn/aYDp/2mA6f9pgGnAaf+pgKn/6b/pgKn/qYCp/6mAacApwCnAKcApwCn/6YCp/6mAacAp/+mAqf+pgGn/6YCp/6mAqf+pgCnAqf+pgGnAKf/pgGnAKf/pgGnAKcApwCn/6YCp/2mBaf6pgWn/KYDp/6mAqf+pgGn/6YCp/2mA6f+pgGnAKf/pgGn/6YBp/+mAacAp/+mAaf+pgOn/qYBpwCn/6YBpwCn/6YBpwCnAKcApwCn/6YBpwCnAKcApwCn/6YBpwCn/6YCp/2mA6f+pgGnAKf/pgGn/6YCp/2mBKf7pgSn/6b+pgOn/aYDp/2mA6f9pgOn/qYApwGn/6YCp/2mAqf/pgGnAKf/pgCnAKcBp/+mAaf/pgCnAaf/pgCnAaf/pgCnAaf+pgOn/aYCp/+mAKcBp/+mAacAp/+mAaf/pgFZAFkAWQBZ/1gBWQBZAFkAWQBZAFkAWf9YAVkAWQBZAFn+WAJZ/1gAWQFZ/lgDWf1YAVkAWQBZAFkBWf9YAFkBWf5YA1n9WANZ/VgDWf5YAFkBWf9YAVkAWf9YAVkAWf9YAVkAWQBZAFkAWf9YAln+WAGnAKf/pgOn+6YFp/ymA6f+pgGn/6YBp/+mAaf/pgGn/qYCp/+mAKcBp/6mAqf/pgCnAKcApwGn/6YBp/6mAqf/pgCnAaf/pgGn/6YApwGn/6YCp/2mAqf/pgGn/6YCp/2mAqcAp/6mA6f9pgOn/aYDp/2mAqcAp/6mA6f+pgCnAqf9pgKnAKf/pgGn/6YApwGn/6YApwGn/qYCpwCn/qYCp/+mAKcCp/2mA6f8pgWn/KYDp/2mA6f9pgOn/qYApwKn/aYCp/+mAaf/pgGn/qYCp/+mAKcBp/6mAqf/pgCnAKcApwCnAKcAp/+mAqf/pgCnAKf/pgKn/6YApwGn/6YApwGn/6YBp/+mAacAp/+mAqf9pgSn+6YFp/umBaf8pgKnAKf/pgGn/6YBpwCnAKf/pgKn/qYBpwCn/6YCp/2mA6f9pgOn/qYBp/+mAaf/pgGn/6YBp/+mAKcBp/+mAKcApwCnAKcBp/6mAqf+pgKn/qYCp/6mAqf+pgGnAKf/pgOn/KYDp/6mAacApwGn/aYFp/qmBaf9pgGnAaf/pgCnAKf/pgGnAaf+pgKn/qYApwKn/qYCp/+m/6YBpwCnAKcBWf5YAVkAWQBZAFkBWf5YAln/WP9YA1n8WARZ/VgBWQFZ/lgCWf5YAln+WAJZ/1gAWQFZ/lgDWfxYBFn9WANZ/lgAWQFZ/1gBWQBZ/lgEWftYBVn7WARZ/lgBWQBZ/lgDWf1YA1n+WABZAVn/WAFZ/1gApwKn/aYDp/6mAKcCp/6mAacAp/+mAacAp/+mAaf/pgGnAKf/pgGn/6YApwKn/aYCp/+mAaf+pgOn/aYBpwGn/qYCpwCn/qYCp/+mAKcApwGn/qYDp/2mAqf+pgKn/6YBp/+mAKcBp/+mAqf9pgKn/6YBp/+mAaf+pgOn/aYCp/+mAKcBpwCn/qYDp/2mAqcAp/6mA6f9pgOn/aYCp/+mAKcBp/+mAaf/pgCnAaf+pgOn/qYApwGn/6YApwKn/aYCp/+mAaf/pgCnAaf+pgOn/aYCp/+mAaf/pgGn/6YBp/+mAaf/pgGn/6YApwGn/6YBp/+mAKcBp/+mAacAp/+mAacAp/+mAqf9pgSn/KYDp/2mAqcApwCnAKf/pgGn/6YBpwCnAKcAp/+mAaf/pgKn/qYBp/+mAKcCp/2mA6f9pgKn/6YBp/+mAaf/pgCnAaf/pgCnAaf/pgCnAaf9pgSn/aYCp/6mAqf9pgSn/KYDp/6mAqf+pgKn/qYCp/+mAKcApwCnAaf+pgKn/qYBpwCn/6YCp/2mBKf7pgWn/KYDp/6mAqf9pgOn/6b/pgKn/qYApwOn/KYDp/+m/6YBpwCn/6YCWf5YAFkCWf1YA1n+WAFZAFkAWf9YAVkAWQBZAFn/WAFZAFkAWQBZAFkAWQBZAFkAWQBZAVn+WAFZAFn/WANZ/FgEWfxYBFn9WAJZ/lgCWf9YAFkBWf5YAln+WAJZ/lgCWf5YAln/WABZ/1gCWf5YA1n8pgOn/qYCp/+mAKcApwCnAKcBp/6mA6f9pgOn/aYCp/+mAacAp/6mA6f9pgOn/aYCp/+mAaf/pgCnAaf/pgGn/qYDp/ymBaf7pgSn/aYCp/+mAKcBp/6mAqf/pgCnAaf+pgKn/6YBp/+mAKcBp/+mAaf/pgCnAaf/pgGn/qYCp/+mAacAp/+mAaf/pgGn/6YBp/+mAaf/pgCnAKcBp/+mAKcBp/6mA6f9pgKn/6YApwKn/aYCp/+mAKcBpwCn/qYDp/2mAqf/pgGn/6YBp/+mAaf/pgGn/6YBp/+mAacAp/6mA6f9pgKnAKf+pgKn/qYCp/+mAKcApwCnAKcApwCnAKcAp/+mAqf+pgKn/qYBpwCnAKcBp/2mBKf9pgKn/qYBpwCnAaf/pgCnAKf/pgOn/KYEp/2mAqf+pgKn/qYCp/+mAKcApwCnAKcApwCnAKcApwGn/qYCp/6mAacBp/6mAqf+pgKn/qYCp/2mBKf9pgGnAKcApwCnAaf9pgOn/qYCp/6mAqf+pgKn/qYCp/6mAqf/pgCnAaf+pgKn/6YApwGn/qYCp/+mAKcApwGn/qYCp/6mAqf/pgGn/6b/pgOn/VgCWQBZ/lgCWf9YAVn+WANZ/FgEWf5YAFkAWQFZ/lgDWf5Y/1gCWf9Y/1gDWfxYA1n/WP9YAln/WABZAVn+WAJZ/1gBWf9YAFkBWf5YAln+WAJZ/1gAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFn/WAJZ/qYCp/6mAacApwCn/6YBpwCn/6YCp/2mA6f+pgCnAqf9pgSn/KYCpwCn/6YCp/6mAacBp/6mAqf+pgKn/6YBp/+mAKcBp/+mAaf/pgCnAacAp/+mAaf/pgCnAqf9pgKn/6YApwGn/qYCp/+m/6YDp/ymA6cAp/6mA6f9pgKn/6YApwGn/qYEp/umBKf9pgGnAaf/pgCnAaf9pgWn+qYHp/mmBqf7pgSn/qYApwKn/KYFp/ymAqf/pgCnAaf/pgCnAaf+pgKn/qYCp/+mAKcAp/+mAqf/pgCnAKcAp/+mA6f8pgOn/6b+pgWn+qYFp/ymAqcApwCnAKf/pgGnAKf/pgKn/aYDp/6mAacApwCn/6YCp/6mAqf+pgGnAaf+pgKn/qYBpwGn/6b/pgKn/qYCp/+m/6YBpwCnAKcAp/+mAacAp/+mAqf+pgGnAKf/pgGnAKf/pgGnAKf/pgKn/aYEp/ymBKf8pgOn/qYCp/6mAqf9pgOn/qYBpwCn/6YBpwCn/6YCp/6mAacBp/2mA6f/pgCnAKcAp/+mAqf/pgCnAaf/pgCnAKcBp/6mA6f8pgOn/6b/pgOn/KYEp/2mAqf/pgFZ/lgDWf1YA1n9WANZ/VgCWQBZ/1gCWf1YA1n9WANZ/VgCWf9YAFkBWf5YAln/WABZAVn+WAJZ/lgCWf5YAln+WAFZAFkAWQBZAFn/WAJZ/lgCWf5YAVkAWQBZ/1gCWf5YAln/WABZAFkBWf9YAFkBWf+mAaf/pgGn/6YBp/+mAKcCp/2mAqf/pgCnAaf+pgKn/qYDp/2mAacApwCnAKcBp/6mAaf/pgKn/aYEp/ymAqf/pgGn/6YCp/2mA6f9pgOn/qYBp/+mAaf/pgKn/aYCpwCn/qYEp/umBKf+pgCnAqf9pgKn/6YBp/+mAKcApwCnAaf/pgCnAKcApwCnAaf/pgCnAaf+pgKn/6YApwGn/qYCp/6mAqf+pgKn/qYCp/6mAqf9pgSn/KYEp/ymA6f+pgGnAKcApwCnAKcApwCnAKcApwCnAaf+pgKn/qYCp/+mAKcBp/6mAqf/pgCnAaf+pgKn/6YApwCnAKcBp/6mAqf+pgKn/6b/pgKn/aYDp/+m/6YCp/2mAqcBp/6mAqf9pgSn/aYCp/+mAKcApwGn/qYDp/2mAqf/pgCnAaf+pgOn/KYEp/2mAacBp/6mAqf/pgCnAKcBp/6mA6f8pgSn/aYDp/2mAqf/pgGn/6YBp/+mAaf/pgGn/6YApwGn/qYDp/6mAKcApwCnAKcCp/ymBKf8pgSn/aYBpwCnAaf+pgOn+6YGp/umA6f/pgCnAKcApwCnAKcAp/+mAqf+pgGnAKf/WAJZ/lgBWf9YAln+WAFZAFn/WAJZ/VgEWftYBVn8WAJZAFn/WAJZ/VgCWQBZ/1gBWf9YAVkAWf9YAVn/WAJZ/lgBWQBZ/1gCWf5YAln/WP9YAln+WAJZ/1j/WAJZ/lgCWf5YAln9WARZ/FgDWf5YAln+pgKn/qYBpwCnAKf/pgKn/aYDp/6mAacAp/+mAacApwCn/6YCp/6mAacAp/+mAacApwCnAKf/pgGnAKf/pgKn/aYDp/6mAKcCp/2mBKf8pgKnAKcApwCn/6YCp/6mAqf9pgOn/qYBpwGn/KYFp/umBaf9pgGn/6YBp/+mAqf/pv+mAqf9pgSn/KYEp/umBqf6pgWn/KYDp/6mAacApwCnAKf/pgGnAKcApwCnAKf/pgKn/qYCp/+mAKcApwGn/6YBp/+mAKcBp/6mA6f8pgSn/aYCp/6mAqf+pgKn/qYCp/6mAacAp/+mAqf+pgGn/6YBp/+mAqf+pgGn/6YBpwCnAKf/pgGnAKcAp/+mAaf/pgGnAKf/pgGn/6YBp/+mAqf+pgGnAKf/pgOn/KYDp/6mAacApwCn/6YBpwCn/6YCp/2mA6f+pgGnAaf+pgGnAKf/pgKn/6b/pgOn+6YGp/umA6f/pgCnAKcApwCnAKcApwCnAKcApwGn/qYBpwCnAKcBp/6mAqf+pgKn/6YApwCnAKcApwCnAKcApwCnAKcAp/+mAqf9pgOn/6b/pgKn/aYDp/+m/6YCp/2mA6f+pgGnAFn/WABZAVn/WAJZ/lgAWQJZ/VgEWfxYA1n+WAFZAFn/WAJZ/lgAWQJZ/VgDWf5YAVn/WAFZ/1gBWQBZ/1gBWf9YAVkAWf9YAln9WANZ/lgBWQBZ/1gBWQBZ/1gBWQBZ/1gCWf1YA1n+WAFZAFn/WAFZAKcAp/+mAaf/pgKn/qYCp/2mA6f+pgGnAKf/pgKn/aYDp/6mAacAp/+mAaf/pgGn/6YBp/6mA6f9pgKn/6YApwGn/6YBp/+mAKcBp/+mAaf/pgCnAKcApwCnAaf+pgKn/qYBpwGn/aYEp/ymA6f+pgGnAKcAp/+mAacApwCnAKcAp/+mAqf+pgGnAKcApwCnAKf/pgGnAKcApwCn/6YCp/6mAacAp/+mAqf+pgKn/aYEp/ymA6f+pgGnAKcAp/+mAaf/pgGnAKf/pgGn/6YApwGn/6YApwCn/6YDp/2mAqf+pgGnAaf/pgGn/6YApwGn/6YApwGn/6YApwGn/qYCp/+mAaf+pgOn/aYBpwGn/qYCp/+m/6YCp/6mAacAp/+mAqf9pgOn/6b/pgKn/aYDp/+mAKcApwCnAKcBp/6mA6f9pgKn/6YApwCnAaf+pgKn/6YApwCnAaf+pgKn/6YApwCnAaf+pgKn/qYBpwCn/6YCp/2mA6f9pgKn/qYDp/2mAqf+pgKn/6YBp/+mAKcBp/+mAaf/pgGn/6YBp/+mAKcBp/+mAaf/pgGn/6YBp/+mAaf/pgGn/6YBp/+mAaf/pgFZ/1gBWf9YAln+WAFZ/1gBWQBZAFn/WAFZ/1gBWQBZ/1gBWf9YAVkAWf9YAVn/WAFZ/1gBWf5YA1n+WABZAVn9WAVZ/FgCWf9Y/1gDWfxYBFn8WARZ/FgEWftYBVn8WANZ/lgAWQFZAFn/WAJZ/FgFWfymA6f+pgGn/6YBpwCn/6YCp/2mAqcAp/+mAqf+pgGn/6YBpwCn/6YCp/2mA6f+pgGnAKcAp/+mAqf9pgOn/6b/pgKn/KYFp/ymA6f+pgGnAKcAp/+mAacApwCnAKf/pgKn/qYCp/6mAacApwCnAKcBp/6mAqf+pgGnAaf+pgKn/qYBpwCnAKcApwCnAKf/pgKn/qYCp/6mAaf/pgKn/qYBp/+mAaf/pgKn/aYDp/2mA6f+pgGn/6YBp/+mAqf9pgOn/qYBp/+mAaf/pgKn/qYApwGn/6YBp/+mAaf/pgGn/6YApwGn/6YBp/+mAKcBp/+mAaf/pgGn/6YBp/6mA6f9pgOn/aYCp/+mAKcBp/6mAqf/pgCnAKcAp/+mAqf+pgKn/qYBpwCnAKcAp/+mAqf+pgOn/KYEp/umBqf6pgWn/aYApwKn/aYCp/+mAKcBpwCn/6YBp/6mAqcAp/+mAqf8pgSn/qYApwKn/KYEp/6mAacAp/+mAacAp/+mAqf+pgKn/aYDp/6mAacAp/+mAKcBp/+mAKcCp/ymBKf9pgOn/aYCp/+mAacAp/+mAKcBp/+mAaf+pgKn/qYDp/ymA6f+pgFZAFn/WAJZ/VgDWf5YAVkAWQBZ/1gCWf5YAln+WAJZ/lgCWf5YAln+WAJZ/lgCWf5YAVkAWQBZAFkAWQBZ/1gCWf5YAln+WAJZ/lgCWf5YA1n8WARZ/FgEWf5YAVn/WABZAFkBWf9YAVn/WABZAVn/WACnAaf+pgSn+6YFp/umBaf7pgan+qYGp/qmBaf8pgSn/aYCp/2mBKf9pgGnAKf/pgGnAKf/pgGnAKf/pgCnAaf+pgSn/KYDp/2mAqcApwCn/6YBp/+mAacAp/+mAaf/pgGn/6YBp/+mAacAp/+mAaf/pgGnAKf/pgCnAacAp/+mAaf+pgOn/aYCpwCn/qYDp/ymA6cAp/+mAKcBp/2mBqf6pgOnAKf+pgSn+6YFp/umBaf8pgKnAKf/pgGn/6YBp/+mAaf/pgGn/qYCp/+mAKcBp/+mAKcBp/6mAqf/pgCnAaf/pgCnAKcApwCnAaf/pgCnAKcBp/6mA6f9pgOn/aYCpwCn/6YCp/6mAacAp/+mAqf9pgSn+6YFp/umBKf9pgKn/6YApwCnAKcApwCnAKcApwCnAKcApwCnAKf/pgKn/qYBpwCn/6YBpwCn/6YBpwCn/6YBp/+mAaf/pgKn/aYDp/6mAacApwCnAKf/pgKn/qYCp/+m/6YCp/6mAqf/pgCnAKcApwCnAKcBp/2mBKf8pgOn/qYBp/+mAqf9pgOn/aYCpwCn/6YBp/+mAKcBp/+mAaf/pgCnAaf+pgKnAKf+WAJZ/1gAWQFZ/1gAWQFZ/1gAWQFZ/1gAWQJZ/FgEWf1YAln/WABZAFkBWf9YAVn+WAJZ/1gBWf9YAFkBWf5YA1n9WAJZ/1gAWQFZ/1gAWQBZAVn+WANZ/FgDWf9YAFkAWQFZ/lgDWf1YAVkBWf9YAVn/pgCnAaf/pgCnAKcBp/+mAaf+pgKn/qYCp/+mAKcBp/6mAacApwGn/qYCp/+mAKcApwCnAaf/pgGn/qYCp/+mAaf/pgCnAaf/pgGnAKf/pgGn/6YBpwCn/6YBp/+mAaf/pgCnAaf/pgCnAaf+pgOn/KYEp/ymBKf9pgKn/qYCp/6mAqf/pgCnAaf/pgCnAKcBp/+mAaf/pgCnAqf8pgan+aYGp/2mAKcDp/ymA6f+pgKn/qYCp/6mAqf+pgGnAKf/pgKn/qYCp/6mAacAp/+mA6f8pgOn/6b/pgGnAKf/pgKn/aYDp/2mA6f+pgCnAaf/pgGn/6YBp/+mAqf+pgGn/6YBpwGn/qYBpwCnAKcBp/6mAacApwCnAaf+pgGnAKf/pgKn/qYBpwCn/6YBpwCn/6YCp/2mAqcAp/+mAaf/pgCnAaf+pgOn/KYEp/2mAqf/pgCnAaf+pgOn/qYBp/+mAaf/pgKn/aYDp/2mA6f9pgOn/aYDp/2mA6f+pgKn/aYDp/6mAqf/pgCn/6YCp/6mA6f8pgOn/qYCp/+mAKf/pgOn/KYFp/umA6f/pgGn/qYDp/2mAacCp/ymBKf9pgGnAVn+WANZ/VgCWf9YAFkBWf9YAVkAWf9YAFkAWQFZAFn/WAFZ/lgCWQBZ/1gBWf9YAFkBWf9YAVn/WAFZ/lgCWf9YAVn/WAFZ/lgDWf1YA1n9WANZ/VgDWf5YAFkBWf5YA1n9WANZ/FgEWf1YAln/WABZAaf+pgKn/6YApwCnAKf/pgOn/KYEp/ymA6f/pv+mA6f9pgGnAaf+pgKn/qYCp/6mAqf+pgGnAKf/pgKn/qYBp/+mAaf/pgGnAKf/pgGn/6YBp/+mAaf/pgGn/6YCp/ymBaf8pgKnAKf+pgOn/aYDp/2mAqf/pgCnAaf/pgCnAaf+pgOn/aYCp/+mAKcBp/+mAaf/pgCnAaf/pgGn/6YBp/+mAaf/pgCnAaf/pgGn/qYDp/2mAqf/pgCnAqf+pgCnAaf/pgKn/qYBpwCn/6YCp/6mAacBp/6mAqf+pgKn/6YBp/+m/6YDp/2mAqf/pv+mAqf/pgCnAKf/pgKn/qYCp/6mAacAp/+mAqf+pgGnAKf/pgGnAKf/pgGn/6YApwGn/6YApwGn/qYDp/2mAqcAp/+mAaf/pgGnAKcAp/+mAacAp/+mAacAp/+mAqf+pgCnAqf+pgGnAKf/pgGnAaf9pgSn+6YEp/6mAaf/pgGn/qYCp/+mAKcBp/6mAqf/pgGn/qYCp/6mA6f9pgKn/6YApwGn/6YApwGn/6YBp/+mAKcBp/6mA6f9pgGnAaf+pgKn/6YApwGn/6YBp/6mA6f9pgNZ/VgDWf1YA1n9WANZ/VgDWf1YA1n9WANZ/FgEWf1YA1n8WARZ/FgEWf1YAln+WAJZ/1gAWQBZAVn+WAJZ/1gAWQFZ/1gAWQFZ/1gBWf9YAVn/WAFZAFn/WAFZ/1gBWf9YAVkAWf9YAln8WAVZ/FgCWQGn/aYDp/2mAqcAp/+mAaf/pgGn/6YBpwCn/qYDp/6mAacAp/+mAacBp/6mAaf/pgGnAaf+pgGn/6YBpwCnAKcAp/+mAqf+pgKn/6b/pgKn/qYDp/2mAacApwCnAKcApwCn/6YCp/2mA6f9pgOn/aYCp/+mAKcApwGn/qYBpwCnAKcApwCnAKf/pgKn/qYBpwCn/6YCp/6mAacApwCnAKcApwCn/6YCp/6mAqf+pgGn/6YBp/+mAacAp/+mAaf/pgGn/6YBpwCn/6YCp/2mA6f+pgGnAKcAp/+mAacAp/+mAqf9pgOn/qYCp/6mAKcCp/2mA6f/pv6mBKf7pgWn/KYDp/6mAacAp/+mAqf+pgGnAKf/pgGnAKf/pgGn/6YBp/+mAaf+pgOn/qYApwGn/6YBp/+mAaf/pgGn/6YBp/+mAaf/pgCnAqf8pgSn/aYCpwCn/qYCp/+mAaf/pgGn/6YBp/+mAaf/pgKn/aYDp/2mA6f+pgGnAKf/pgGn/6YBpwCnAKcApwCn/6YBpwCnAKcApwCn/6YCp/6mAacApwCnAKcApwCn/6YDp/ymBKf9pgGnAaf+pgKn/6b/pgOn/KYFWfpYBln7WANZAFn+WANZ/VgCWf5YAln/WABZAFkAWf9YA1n8WARZ/FgEWfxYBFn9WAFZAFn/WAFZAFn/WAFZ/1gBWf9YAVn/WAFZ/1gBWQBZAFkAWf9YAln+WANZ/FgDWf9Y/1gCWf1YA1n+WAJZ/VgDp/2mA6f+pgGnAKcAp/+mAqf9pgSn/KYDp/6mAqf+pgGnAKcAp/+mAqf9pgOn/6b/pgGn/6YBpwCn/6YCp/2mBKf7pgWn/KYCpwCn/6YBp/+mAKcApwGn/6YApwCnAKcBp/+mAKcApwCnAaf/pgCnAKcApwCnAKcBp/6mAacBp/2mBaf7pgOnAKf+pgKnAKf+pgSn/KYBpwGn/6YBpwCn/qYCp/+mAKcBp/+mAacAp/6mA6f+pgGnAKf/pgGnAKf/pgGnAKf+pgOn/aYDp/2mAqf/pgGn/6YBp/+mAKcBp/+mAKcCp/umB6f5pgan+6YEp/2mA6f+pgCnAaf/pgGnAKf/pgGn/6YBpwCn/6YBp/+mAaf/pgKn/aYDp/2mAqcAp/+mAaf/pgCnAqf9pgOn/aYDp/6mAaf/pgGn/6YCp/2mA6f9pgKnAKf+pgSn+6YEp/6mAKcBpwCn/6YBp/+mAaf/pgKn/qYApwKn/aYDp/6mAaf/pgKn/aYCpwCn/6YCp/2mAqf/pgKn/qYBp/+mAKcBpwCnAKf/pgGn/6YBpwCn/6YCp/6mAacAp/+mAqf+pgGnAKcApwCn/6YCp/6mAqf+WAFZAFkAWQBZAFkAWf9YAVkAWQBZAFn+WANZ/VgCWQBZ/lgDWf1YAln/WAFZ/lgEWfpYBln8WAJZAFn+WAJZAFn/WAFZ/1gBWQBZ/1gBWf9YAln+WAFZAFkAWQBZAFkAWf9YA1n8WANZ/1j+WARZ/FgDp/2mA6f9pgOn/qYApwGn/qYDp/2mAqf/pgCnAaf/pgGn/qYDp/6mAaf/pgGn/6YCp/6mAacAp/+mAacBp/2mA6f+pgCnAaf/pgCnAaf/pgGn/qYDp/2mAqcAp/+mAqf9pgOn/aYDp/6mAacAp/+mAaf/pgGn/6YCp/2mA6f9pgKn/6YCp/2mBKf7pgWn/KYDp/6mAqf+pgKn/qYBpwCnAKf/pgGn/6YCp/2mBKf7pgSn/6b+pgSn/KYDp/+m/6YBpwGn/qYCp/6mAacApwCn/6YBp/+mAKcBp/6mAqf+pgKn/6YApwCnAaf+pgOn/aYCpwCn/qYDp/6mAaf/pgGn/6YCp/6mAKcCp/2mBKf8pgOn/aYDp/6mAaf/pgGn/6YBpwCn/qYDp/2mAqcAp/+mAacAp/+mAqf+pgGnAKcApwGn/6YAp/+mA6f8pgWn+qYFp/2mAqf/pv+mA6f7pgen+aYGp/umA6f+pgKn/6YBp/6mAqf+pgKn/6YApwGn/qYCp/6mAacApwCnAKcAp/+mAaf/pgKn/qYBpwCn/6YBp/+mAqf+pgKn/qYBpwCnAKcApwCnAKcApwCnAKcAp/+mA1n8WARZ/FgDWf9YAFkAWf9YAln+WAJZ/lgBWQBZ/1gCWf5YAVkAWf9YAln+WAFZAFn/WAJZ/lgBWf9YAVkAWf9YAVn/WAFZ/1gBWQBZ/1gBWf9YAVkAWf9YAVn/WAFZ/1gBWf9YAVn/WABZAFkBWf9YAKcApwCnAaf+pgKn/qYCp/+mAKcApwCnAKcApwCnAKcApwCnAKcApwCnAKcApwCnAKcApwCn/6YCp/2mBKf7pgan+qYFp/ymA6f+pgGnAKcAp/+mAqf9pgSn/KYDp/2mA6f+pgKn/qYBp/+mAaf/pgGn/6YBp/6mAqf/pgCnAKcApwCnAaf/pgGn/qYDp/ymBaf7pgSn/aYCp/6mA6f8pgSn/KYEp/ymBKf9pgGnAKf/pgKn/6YApwCn/6YCp/6mAqf+pgKn/qYCp/6mAqf+pgOn/KYEp/ymA6f/pv+mAqf+pgGnAaf9pgSn/KYDp/+mAKcApwCnAKcApwCnAKcApwCnAKcAp/+mAqf+pgKn/qYCp/6mAqf/pgCnAKcApwCnAaf+pgKn/aYEp/ymA6f/pv6mBKf8pgOn/qYBp/+mAqf9pgOn/aYDp/6mAKcBp/+mAaf/pgGn/6YBp/+mAKcBp/+mAKcBp/6mAqf+pgKn/6YApwCn/6YDp/2mA6f9pgKn/qYCp/+mAacAp/+mAKcBp/+mAacAp/+mAacAp/+mAacAp/+mAqf+pgGnAKcApwCnAKcApwCnAaf+pgOn/aYDp/1YA1n9WANZ/VgDWf1YA1n9WANZ/VgCWf9YAVn/WAJZ/FgEWf5YAFkCWf1YAlkAWf5YA1n9WANZ/lgAWQFZ/1gBWQBZ/1gBWQBZAFn/WAFZAFkAWQBZAFn/WAJZ/lgCWf9YAFkBWf5YAln/WABZAVn+WAGnAKcAp/+mAaf/pgGn/6YBp/6mA6f+pgGn/6YBp/+mAqf9pgOn/aYDp/6mAKcBp/6mAqcAp/2mBKf8pgOn/6b/pgGnAKcAp/+mAqf9pgSn/KYDp/2mA6f+pgKn/aYDp/2mBKf8pgOn/qYBpwCnAKcApwCnAKcAp/+mAqf/pgGn/qYBpwCnAKcApwGn/aYEp/ymAqcBp/6mAacAp/+mAqf+pgGnAKcAp/+mAqf9pgSn/KYDp/6mAacAp/+mAacApwCn/6YBp/+mAqf+pgGnAKf/pgGnAKcApwCnAKf/pgGnAKcApwCnAKf/pgGnAKcApwCn/6YCp/2mBKf8pgOn/qYCp/6mAacAp/+mA6f7pgan+6YDp/+m/6YDp/2mAacBp/6mA6f9pgKn/6YApwGn/6YBp/+mAKcBp/+mAaf+pgOn/KYEp/6mAKcBp/+mAKcBp/+mAaf/pgGn/6YBpwCn/6YApwKn/KYFp/umBKf+pgCnAaf+pgOn/qYApwKn/aYDp/2mA6f9pgOn/aYDp/6mAacAp/+mAacBp/6mA6f8pgKnAKcApwCnAKf+pgOn/aYDp/2mAqf/pgGnAKf+pgOn/KYFWftYA1n/WABZAVn+WAJZ/lgDWf1YAln/WABZAFkBWf5YAln+WAFZAVn+WAJZ/1j/WANZ/FgEWf1YAln+WANZ/VgBWQBZ/1gDWf1YAln9WARZ/FgEWfxYA1n/WP9YAln9WANZ/1j/WAJZ/VgDWf9YAFn/pgKn/qYCp/6mAacApwCnAKcAp/+mAqf9pgOn/qYBp/+mAaf+pgOn/aYDp/2mA6f9pgKnAKf+pgOn/aYBpwGn/qYCp/6mAqf+pgKn/6YApwGn/6YApwGn/6YBp/+mAaf+pgOn/KYEp/2mAqf/pgCnAKcApwCnAKcApwGn/qYCp/6mAacBp/6mAqf+pgGnAaf+pgKn/qYCp/+mAaf/pgCnAqf9pgOn/qYBp/+mAaf/pgGn/6YBp/+mAacAp/6mBKf8pgOn/qYBpwCnAKcAp/6mBKf7pgWn/KYCpwCn/6YBp/+mAqf9pgOn/qYBpwCn/6YApwKn/aYDp/2mAqf/pgGnAKf/pgGn/6YBpwCn/6YBpwCn/6YCp/2mA6f+pgGnAKf/pgGnAKf/pgGn/6YApwGn/6YBp/+mAKcBp/+mAaf/pgCnAaf/pgCnAaf/pgCnAKcApwGn/6YBp/6mA6f9pgOn/aYCpwCn/6YCp/6mAaf/pgGnAaf+pgGnAKf/pgKn/qYBpwCnAKcAp/+mAqf/pgCnAKf/pgKn/qYCp/+m/6YBp/+mAqf/pv+mAqf9pgSn/aYBpwCnAKcApwCnAKf/pgKn/lgBWQBZ/1gCWf5YAVkAWf9YAln+WAFZAFn/WAJZ/lgBWf9YAFkBWQBZ/lgDWfxYBFn9WAJZ/1gAWQFZ/1gAWQFZ/lgDWf1YA1n9WAJZ/1gBWf9YAVn/WAFZ/1gBWf5YA1n9WAJZ/1gAWQBZAFkBWf5YA6f8pgSn/qYApwGn/6YApwKn/aYDp/ymBaf7pgSn/qYApwGn/6YBp/+mAaf/pgGnAKf/pgGn/6YBpwCn/6YBpwCn/qYDp/2mA6f+pgGn/6YBpwCn/6YBpwCn/6YCp/2mA6f+pgGnAKf/pgKn/qYBpwCn/6YCp/6mAaf/pgGn/6YBp/+mAKcBp/+mAKcBp/+mAacAp/6mBKf7pgWn/aYBpwCnAKf/pgKn/qYCp/6mAacApwCnAKcAp/+mAqf+pgGnAKf/pgGnAaf9pgOn/qYBpwCnAKf/pgKn/qYCp/6mAqf+pgKn/6YApwCnAKcApwCnAKcApwCnAKcAp/+mAqf/pv+mAqf+pgGnAKf/pgGnAKcAp/+mAqf9pgOn/qYBpwCn/6YCp/2mA6f+pgGnAKf/pgGnAKcApwCn/6YBpwCnAaf+pgGn/6YBpwCnAKf/pgGn/6YBpwCn/6YBp/+mAacAp/6mA6f9pgKnAKf+pgOn/aYCpwCn/6YCp/2mA6f+pgGnAKcAp/+mAqf+pgGnAKf/pgKn/qYCp/2mBKf7pgWn/KYCpwCn/6YBp/+mAKcBp/+mAaf/pgCnAaf/pgGn/6YBp/+mAVn/WAJZ/VgEWftYBFn+WAFZAFn/WAFZ/1gBWQBZ/1gBWf9YAln+WAJZ/VgDWf9Y/1gCWf5YAVkAWQBZ/1gBWQBZ/1gCWf1YAln/WABZAln9WANZ/VgCWQBZ/1gCWf1YA1n+WAFZAFn/WAFZ/1gBWQBZ/qYDp/6mAKcCp/ymBKf+pgCnAaf+pgKn/6YBp/6mAqf+pgGnAaf+pwKo/qcAqAKo/qcCqP6nAagAqACoAaj9pwSo/acCqP+nAKgAqACoAaj+pwKo/qcCqP6nAqj+pwKo/qcBqACo/6cCqP6nAqj9pwOo/acDqP+n/6cCqP6nAaj/pwKo/acEqPynAqgAqP+nAaj/pwGo/6cBqACo/6cCqP6nAagAqACoAaj+pwKo/qcBqAGo/qcCqP2nA6j+pwKo/qcAqAGo/6cCqP6nAaj/pwGo/6cCqP6nAaj/pwGo/6cBqACo/qcEqPunBKj+pwGo/6cBqP+nAaj/pwCoAaj/pwGo/6cAqACoAqj9pwKo/6cAqAGoAKj+pwKo/6cBqP+nAaj+pwOo/acDqP2nA6j9pwOo/acDqP6nAagAqP+nAagAqP+nAqj+pwGoAKj/pwKo/qcBqAGo/acEqP2nAagBqP2nBKj9pwGoAKj/pwKo/qcBqACo/6cBqACoAKgAqP+nAaj/pwKo/qcBqACo/6cBqACo/6cCqP6nAqj9pwSo/KcEqP2nAagAqP+nAqj+pwKo/qcBqACoAKgAqACoAKgAqABYAFgAWP9XAlj+VwFYAVj+VwFYAFgAWABYAVj+VwFYAVj+VwJY/1cAWABYAFgAWAFY/1f/VwJY/1cAWAFY/VcEWP1XAlj/VwBYAFgBWP5XA1j9VwJYAFj/VwFY/1cBWP9XAVgAWP5XA1j9VwJY/1cAWAGo/6cBqP+nAaj/pwGo/6cBqACo/6cBqP+nAagAqP+nAaj/pwGo/6cBqP+nAKgAqACoAaj/pwCoAKgAqACoAqj9pwOo/acDqP2nBKj8pwSo/KcDqP6nAqj+pwKo/qcBqACo/6cBqACo/6cBqP+nAaj/pwGo/6cAqAGo/6cBqP+nAKgBqP6nAqgAqP6nA6j9pwKo/6cBqP+nAaj/pwCoAaj/pwGo/6cBqACo/6cCqP6nAagBqP6nAqj/p/+nA6j8pwSo/KcEqP2nAagAqACoAKgAqACoAKgAqACoAKj/pwKo/qcBqACo/6cBqACo/6cBqACo/6cBqACo/6cBqACo/6cBqP+nAagAqP+nAaj+pwSo/KcDqP6nAKgCqP6nAagAqP+nAagAqP+nAagAqP6nA6j9pwKoAKj+pwOo/KcEqPynBKj9pwKo/6f/pwKo/qcBqACo/6cCqP6nAaj/pwGo/6cCqP6nAagBqP2nBKj8pwSo/KcEqP2nAagAqP+nAqj+pwKo/acEqPynA6j+pwKo/qcCqP2nBKj8pwOo/qcBqACo/6cBqP+nAaj/pwGo/6cBqP+nAaj/pwGo/6cAqAKo/KcFWPxXAlj/VwFY/1cBWP9XAVj/VwFY/1cAWAJY/VcDWP1XA1j+VwFY/1cAWAJY/lcBWABY/1cBWAFY/VcEWPxXA1j/V/9XAlj9VwNY/lcBWABYAFgAWABYAFgAWABYAVj+VwNY/FcEWP1XAlj/VwBYAFgBqP6nAqj/pwCoAaj/pwCoAaj+pwOo/acDqP2nAqj/pwCoAaj+pwOo/acCqP+n/6cDqP2nAqj/p/+nA6j9pwKo/6f/pwKo/6cAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqP+nAqj+pwGoAKj+pwSo/KcCqACo/qcEqPunBaj8pwKo/6cBqACoAKj/pwCoAagAqACo/6cBqP6nA6j+pwGo/6cAqAGoAKgAqACo/qcDqP6nAqj+pwGo/6cBqP+nAaj/pwGoAKj+pwOo/acDqP6nAKgBqP+nAaj/pwGo/qcEqPunBKj+pwGoAKj/pwGo/6cCqP6nAKgCqP2nA6j+pwCoAqj9pwOo/acCqP+nAaj/pwCoAaj+pwOo/KcEqP2nA6j8pwSo/acDqP2nA6j9pwOo/qcBqACoAKgAqP+nAqj+pwKo/qcCqP+nAKgBqP6nAqj/pwGo/6cBqP+nAaj/pwGo/6cBqACo/6cBqP+nAaj/pwGo/6cAqAKo/acCqP+nAKgBqP+nAKgBqP6nA6j8pwSo/acCqP+nAKgAqACoAKgAqACoAKgAqP+nAqj+pwKo/qcBqP+nAqj+pwGo/6cBqACo/1cBWABY/1cCWP5XAVgAWABY/1cCWP5XAlj+VwJY/lcCWP9XAFgBWP9XAFgAWAFY/lcDWPxXA1j+VwJY/lcCWP5XAVgAWABYAFgBWP1XA1j+VwFYAVj9VwNY/VcEWPxXA1j9VwNY/lcBWABY/lcDWP5XAKgBqP+nAKgCqPynBKj9pwKoAKj/pwCoAaj+pwSo+6cFqPynAqgAqP+nAqj9pwSo+6cFqPynA6j+pwKo/acEqPynBKj8pwSo/acBqAGo/qcCqP+nAKgAqAGo/qcCqP+nAKgAqAGo/qcCqP+n/6cDqPynBKj9pwGoAaj9pwWo+6cDqP6nAagBqP6nAqj+pwGoAaj+pwGoAaj+pwOo/acCqP6nA6j9pwKo/6cAqAGo/qcDqP2nA6j9pwKo/6cCqP2nA6j8pwWo/KcCqP+nAKgBqP+nAKgAqAGo/6cBqP6nAqj+pwOo/qcAqAGo/6cAqAGo/6cAqAGo/qcCqP+nAKgBqP6nAqj+pwKo/6cAqACoAaj9pwWo+qcFqP6nAKgAqACoAKgAqAGo/qcCqP6nAagAqAGo/qcCqP6nAagBqP6nA6j9pwKo/qcCqP+nAKgBqP6nAqj+pwGoAKgBqP6nAqj+pwKo/6cAqACoAaj+pwKo/qcBqACoAKgAqACo/6cBqACo/6cCqP6nAKgDqPunBaj8pwKoAaj+pwGo/6cAqAOo+6cFqPynAqgAqP6nA6j+pwCoAaj+pwKo/6cAqAGo/6cAqABYAVgAWP5XA1j9VwNY/lcAWAFY/1cAWAFY/1cCWPxXBVj6VwdY+lcEWP5XAFgBWP9XAVgAWP9XAVj/VwFYAFj/VwJY/VcDWP5XAVgAWP9XAVj/VwJY/VcEWPtXBVj9VwFYAFgAWABYAFgAWABYAFgAWP+nAagAqACoAKj/pwGoAKgAqACo/6cCqP6nAqj+pwGoAKgAqACoAKgAqP+nAqj+pwGoAKj/pwGoAKj+pwOo/KcEqP6nAKgBqP6nAagBqP+nAKgAqACoAKgAqACoAKgAqAGo/acFqPunBKj+pwCoAaj/pwGo/6cCqP2nA6j+pwCoA6j7pwao+qcEqP+n/6cCqP6nAKgDqPunBqj7pwOo/6cAqACoAKgAqAGo/qcCqP6nAqj+pwKo/6f/pwOo/KcEqP2nAagBqP2nBKj8pwOo/6cAqP+nAagAqACoAaj+pwGo/6cDqPynBKj8pwOo/6cAqACoAKgAqACoAKgAqACoAaj+pwKo/6f/pwOo/acCqP+n/6cCqP6nAagAqP6nBKj8pwKoAKj+pwOo/acCqACo/6cBqP6nAqgAqP+nAaj/pwGoAKj/pwKo/acEqPynBKj9pwKo/6cAqAGo/6cBqP+nAKgBqP+nAaj/pwCoAaj/pwGo/qcDqP2nA6j8pwSo/acCqP+nAKgBqP6nA6j8pwWo+6cEqP2nA6j9pwKo/6cAqAGo/6cAqAGo/6cBqP+nAaj/pwGo/6cBqACoAKj/pwKo/acEWPxXA1j/V/9XAlj9VwNY/lcBWABY/1cBWABY/1cCWP5XAVgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAVj+VwJY/1cAWABYAFgAWAFY/1cAWAFY/lcDWP1XAlj/VwFYAFj/pwGo/qcDqP6nAagAqP6nBKj8pwOo/qcAqAKo/qcBqP+nAagAqP+nAaj+pwOo/qcBqACo/qcEqPunBaj8pwOo/qcBqP+nAagAqP+nAaj/pwGoAKj/pwGo/6cBqP+nAagAqP6nA6j9pwOo/acCqP6nA6j9pwKo/qcCqP+nAKgBqP6nAqj/pwGo/6cBqP+nAKgCqP2nA6j9pwOo/qcBqP+nAKgBqACo/6cBqP+nAKgCqP2nAqj/pwCoAaj/pwCoAaj+pwKo/6cBqP6nA6j9pwKoAKj9pwWo/KcCqACo/qcDqP2nA6j+pwCoAaj+pwOo/qcBqP6nAqj/pwGo/6cAqACoAKgBqP6nA6j9pwGoAKgBqP6nA6j8pwOo/6cAqACoAKj/pwOo/KcFqPunAqgBqP6nA6j+pwCoAaj+pwOo/acEqPynAqgAqP+nAagAqP+nAqj+pwGo/6cCqP6nAagAqP+nAqj9pwOo/acDqP2nA6j+pwGo/qcDqP2nBKj7pwSo/qcBqP+nAaj/pwGo/6cBqP+nAaj/pwCoAaj+pwOo/acDqP2nAqj/pwGoAKj/pwGo/6cBqACo/6cBqP+nAagAqP+nAaj/VwFYAFj/VwFY/1cAWAJY/VcCWP9XAFgBWP9XAFgBWP5XA1j9VwJYAFj+VwNY/VcDWP1XAlgAWP5XBFj7VwRY/lcBWP9XAlj9VwNY/VcDWP5XAFgBWP5XBFj7VwRY/VcCWABY/1cAWAJY/VcDWP5XAVgBqP6nAagAqACoAKgBqP6nAqj+pwKo/qcCqP6nAagAqACoAKgAqP+nAqj+pwKo/qcBqAGo/acEqPynA6j+pwGoAKgAqACo/6cBqACoAKj/pwGo/6cCqP6nAagAqACoAaj/pwCoAKgBqP+nAaj/pwCoAKgBqP+nAKgBqP2nBaj6pweo+KcIqPinB6j7pwOo/6cAqACoAKgAqACoAKgBqP6nAqj+pwKo/6cAqACoAaj+pwOo/KcEqP2nA6j9pwKo/6cBqP6nA6j8pwWo+6cDqP6nA6j8pwSo/acBqAGo/qcCqP+nAaj+pwKo/6cBqP6nA6j9pwKoAKj+pwOo/acCqP+nAaj/pwGo/qcCqP+nAaj/pwCoAKgAqAGo/qcCqP6nAqj/pwCoAKgAqACoAaj+qAKp/6gAqQGq/6kBqv+qAav/qgGsAKz/qwGs/qwDrf2sA679rQGuAa//rgGv/64AsACwAbAAsf+wArH8sQSy/rEBswGz/LIEs/2zA7T+swC1AbX+tAO2/bUDtv21A7f9tgK3/7cBuP63BLn7uAS5/bgCuv+5Abr/ugC7Abv/uwG8/7sAvAG9/7wBvf+9Ab7/vQG//0ABQf4/A0D9PwJA/z4APwA/AT7/PQA+AT3+PAI9/zwAPAA8ADwAOwA7/zoCOv05BDr9OQI5/zj/OAI4/zcCOP02Azf9NgM3/TUDNv41ATUANf40AzT+MwA0AjP8MgUz/DIDMv0xAzL+MAEx/zACMP0vBND8zwPR/tAC0f7RAtL+0QLT/tIC0/7SAtT+0wLU/9QA1QDVANYA1gHW/tUC1/7WA9f81wTY/NcD2f7YAdkA2v/ZAdr/2QLb/doE2/zbBNz82wTd/dwD3f3cAt7/3QDeAd//3gDfAeD+3wPg/d8D4fzgBOH94QLi/+EA4wHj/uIC4/7jAuT/4wDlAOUB5f3lBOb85QPn/+YA5//mAuj95wPo/+j/6ALp/ekD6v7pAer/6gHrAOv/6wHs/+sB7QDtAO3/7ALu/u0B7gHv/e4E7/3vAvD+7wLw/vAC8f/wAPIA8gDyAPMA8wHz/vMC9P7zAfQB9f70AvX/9f/1A/b89gT3/vb/9gT4+vcH+Pr4A/kA+f75A/r++QH6//oB+//6Afz/+wH8//wB/f/8AP0B/v79Av7+/gP//f4DAPz/BAA=");
        sndW.play();
    }

    $(document).ready(function () {
        getLocations();
        loadTableItemsdePedidosparaSurtir();
        //formatTable();

        //sortTable();
    });

    function getDateTime() {
        var now = new Date();
        var year = now.getFullYear();
        var month = now.getMonth() + 1;
        var day = now.getDate();
        var hour = now.getHours();
        var minute = now.getMinutes();
        var second = now.getSeconds();
        if (month.toString().length == 1) {
            var month = '0' + month;
        }
        if (day.toString().length == 1) {
            var day = '0' + day;
        }
        if (hour.toString().length == 1) {
            var hour = '0' + hour;
        }
        if (minute.toString().length == 1) {
            var minute = '0' + minute;
        }
        if (second.toString().length == 1) {
            var second = '0' + second;
        }
        var dateTime = year + '/' + month + '/' + day + ' ' + hour + ':' + minute + ':' + second;
        return dateTime;
    }

    function ajustarCantidad() {
        var location = $("#Locations :selected").text();

        var serializedData = {};
        serializedData.option = "getItemInDefaltLocation";
        serializedData.location = location;
        serializedData.codigo_tras = codigo_tras;

        $.ajax({
            type: "POST",
            url: "../ajax_response.aspx",
            cache: false,
            data: serializedData,
            async: false,
            success: function (data) {
                //alert(data);


                var MyRows = $('table#htmlTable').find('tbody').find('tr');

                for (var i = 0; i < MyRows.length; i++) {
                    var MyIndexValue = $(MyRows[i]).find('td:eq(0)').html().toUpperCase();
                    //alert(MyIndexValue);
                    if (codigo_tras.toUpperCase() == MyIndexValue) {

                        $(MyRows[i]).find('td:eq(4)').html(data);

                    }
                }



                formatTable();
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(textStatus + errorThrown);
            }
        });

    }


    function getLocations() {

        var serializedData = {};
        serializedData.option = "getLocations";

        $.ajax({
            type: "POST",
            url: "../ajax_response.aspx",
            cache: false,
            data: serializedData,
            async: false,
            success: function (data) {
                if (data != "") {
                    var sel = $("#Locations");
                    sel.empty();

                    var lines = [];
                    lines = data.split("]");
                    for (var i = 0; i < lines.length - 1; i++) {
                        var lineVal = [];
                        lineVal = lines[i].split("}");
                        sel.append('<option value="' + lineVal[0] + '">' + lineVal[1] + '</option>');
                    }



                }

            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(textStatus + errorThrown);
            }
        });

    }

    function sortTableToPrint() {
        var rows = $('#htmlTable tbody  tr').get();

        rows.sort(function (a, b) {

            var A = $(a).children('td').eq(7).text().toUpperCase();
            var B = $(b).children('td').eq(7).text().toUpperCase();

            if (A < B) {
                return -1;
            }

            if (A > B) {
                return 1;
            }

            return 0;

        });

        $.each(rows, function (index, row) {
            $('#htmlTable').children('tbody').append(row);
        });
    }

    function sortTable() {
        var rows = $('#htmlTable tbody  tr').get();

        rows.sort(function (a, b) {

            var A = parseInt($(a).children('td').eq(8).text().toUpperCase());
            var B = parseInt($(b).children('td').eq(8).text().toUpperCase());

            if (A < B) {
                return -1;
            }

            if (A > B) {
                return 1;
            }

            return 0;

        });

        $.each(rows, function (index, row) {
            $('#htmlTable').children('tbody').append(row);
        });
    }

    //jQuery.fn.preventDoubleSubmission = function () {
    //    $(this).on('submit', function (e) {
    //        var $form = $(this);

    //        if ($form.data('submitted') === true) {
    //            // Previously submitted - don't submit again
    //            e.preventDefault();
    //        } else {
    //            // Mark it so that the next submit can be ignored
    //            $form.data('submitted', true);
    //            //complete("1");
    //        }
    //    });

    //    // Keep chainability
    //    return this;
    //};

    function complete(pedidoCompleto) {
        var cajas = $("#tbx_cajas").val();

        if (cajas == '' || cajas == "0") {
            alert("ingrese el numero de cajas");
        } else if (isNaN(cajas)) {
            alert("ingrese el numero de cajas");
        } else {
            var pedido = $('#<%=lbl_order.ClientID%>').text();

                var MyRows = $('table#htmlTable').find('tbody').find('tr');
                var array = '';
                for (var i = 0; i < MyRows.length; i++) {
                    var item = $(MyRows[i]).find('td:eq(0)').html();
                    var qty_surt = $(MyRows[i]).find('td:eq(2)').html();
                    if (qty_surt != 0) {
                        array += item + "}" + qty_surt + "]"
                    }
                }

                var location = $("#Locations :selected").text();
                //alert(orderNumber);

                var serializedData = {};
                serializedData.option = "salvarItemsdePedido";

                serializedData.itemsArray = array;
                serializedData.pedido = pedido;
                serializedData.location = location;
                serializedData.pedidoCompleto = pedidoCompleto;
                serializedData.cajas = cajas;
                serializedData.start_date = start_date;

                $.ajax({
                    type: "POST",
                    url: "../ajax_response.aspx",
                    cache: false,
                    data: serializedData,
                    async: false,
                    success: function (data) {
                        //alert(data);
                        dataLOG = data;
                        alert(dataLOG);
                        window.location.href = "pedidosParaSurtir.aspx";
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert(textStatus + errorThrown);
                    }
                });
            }
            //window.location.href = "pedidosParaSurtir.aspx";
            //alert(array);
    }


    function loadTableItemsdePedidosparaSurtir() {
        var pedido = $('#<%=lbl_order.ClientID%>').text();
        var location = $("#Locations :selected").text();

        var serializedData = {};
        serializedData.option = "loadTableItemsdePedidosparaSurtir";
        serializedData.pedido = pedido;
        serializedData.location = location;

        $.ajax({
            type: "POST",
            url: "../ajax_response.aspx",
            cache: false,
            data: serializedData,
            async: false,
            success: function (data) {
                //alert(data);
                dataLOG = data;
                //itemsTable
                var txt = document.getElementById("mydiv");
                txt.innerHTML = dataLOG;
                formatTable();

            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(textStatus + errorThrown);
            }
        });
    }

    function showTransferDiv(code) {
        var location = $("#Locations :selected").text();
        codigo_tras = code;
        var serializedData = {};

        serializedData.option = "getrackForTransferinSurtir";
        serializedData.location = location;
        serializedData.codigo_tras = codigo_tras;

        $.ajax({
            type: "POST",
            url: "../ajax_response.aspx",
            cache: false,
            data: serializedData,
            async: false,
            success: function (data) {
                var myhtml = "<br /><h1>Transferencia de código " + codigo_tras;
                myhtml += "</h1><hr/>"
                if (data == "n/a") {
                    myhtml += "<h1>No existe cantidad disponible</h1>"
                } else {
                    myhtml += data + "<br /><br />"
                    myhtml += "Cantidad: <input type='text' id='txt_qty_for_trans' /><br /><br />"
                    myhtml += "<center><input type='button' value='Transferir' onClick='trasferir();' /></center>"
                }


                $.colorbox({
                    html: myhtml,
                    fixed: true,
                    onClosed: function () { ajustarCantidad(); }
                });
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(textStatus + errorThrown);
            }
        });
    }

    function trasferir() {
        var location = $("#Locations :selected").text();
        var rack = $("#ddl_rack_for_trans :selected").text();
        var qty = $("#txt_qty_for_trans").val();


        if (codigo_tras == "" || rack == "" || qty == "" || isNaN(qty)) {
            alert("Ingrese todos los datos");
        } else {
            var serializedData = {};
            serializedData.option = "TransferenciaRapida";
            serializedData.location = location;
            serializedData.codigo_tras = codigo_tras;
            serializedData.rack = rack;
            serializedData.qty = qty;

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    alert(data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });

        }
    }



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <h1 align="center">Surtir pedido</h1>
    <br />
    <hr />
    <fieldset>
        <legend>Filtrar por</legend>
        <div style="text-align: center;">
            <%--onkeydown = "return(event.keyCode!=13)"--%>
        Seleccione Sucursal:&nbsp
        <select id="Locations" onchange="loadTableItemsdePedidosparaSurtir();"></select>
            &nbsp&nbsp&nbsp
        Ingrese Código:&nbsp
        <input id="tbx_code_html" type="text" onkeydown="addMyItem();" />
            <br />
        </div>
    </fieldset>
    <hr />
    <div style="text-align: center; margin-left: auto; margin-right: auto; width: 1000px; margin-top: 20px;">
        <div id="Printdiv">
            <div style="text-align: center">
                <asp:Label ID="Label1" runat="server" Font-Size="Large">Orden: </asp:Label>
                <asp:Label ID="lbl_order" runat="server" Font-Size="Large"></asp:Label>
                <br />
                <asp:Label ID="Label2" runat="server" Font-Size="Large">Cliente: </asp:Label>
                <asp:Label ID="lbl_cliente" runat="server" Font-Size="Large"></asp:Label><br />
                <asp:Label ID="Label3" runat="server" Font-Size="Large">Paquetería: </asp:Label>
                <asp:Label ID="lbl_paqueteria" runat="server" Font-Size="Large"></asp:Label><br />
                <asp:Label ID="lbl_pieza_lbl" runat="server" Font-Size="100px"></asp:Label>
                <asp:Label ID="lbl_pieza_qty" runat="server" Font-Size="100px"></asp:Label><br />
            </div>
            <hr />
            <div id="mydiv">
            </div>
            <asp:Label ID="lbl_msg" runat="server" Text="" ForeColor="Green"></asp:Label>
            <hr />
        </div>
        <br />
        Ingrese Número de Cajas:
        <input id="tbx_cajas" type="text" />
        <%--<input type="submit" value="Completar" onclick="complete('1');" />--%>
        <%--<button type="button" onclick="complete('1');" >Completar</button>--%>
        <%--<button type="button" onclick="complete('0');" style="display:none" >Salvar Parcial</button>--%>
        <button type="button" onclick="PrintElem('#Printdiv');">Imprimir</button>
        <%--<input type=button name=print value="Imprimir" onclick="PrintElem('#Printdiv')">--%>
    </div>



</asp:Content>

