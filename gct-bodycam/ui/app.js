const monthNames = ["OCK","SBT","MRT","NSN","MYS","HAZ","TEM","AGU","EYL","EKM","KAS","ARA"];
$(document).ready(function(){
    
    $(".bodycam").hide();
    window.addEventListener("message", function(event){
        if(event.data.open == true)
        {
			var month = monthNames[(event.data.month - 1)]
			var grade = event.data.jobGrade.toUpperCase();
			var job = event.data.jobName;
			
			if (job == 'sheriff') {
				$(".logo").attr("src", "lssd.png");
				job = 'LOS SANTOS SERIF DEPARTMANI';
			}
			else if (job == 'police') {
				$(".logo").attr("src", "lspd.png");
				job = 'LOS SANTOS POLIS DEPARTMANI';
			}
			else {
				$(".bodycam").fadeOut();
			}
			
			if (grade.indexOf('Ğ') >= 0) {
				grade = grade.replace('Ğ', 'G');
			}
			else if (grade.indexOf('Ş') >= 0) { 
				grade = grade.replace('Ş', 'S');
			}
			else if (grade.indexOf('Ü') >= 0) { 
				grade = grade.replace('Ü', 'U');
			}
			else if (grade.indexOf('Ö') >= 0) { 
				grade = grade.replace('Ö', 'O');
			}
			else if (grade.indexOf('İ') >= 0) { 
				grade = grade.replace('İ', 'I');
			}
			else if (grade.indexOf('Ç') >= 0) { 
				grade = grade.replace('Ç', 'C');
			}
			else { 
				grade = grade
			}
				
            $(".bodycam").fadeIn();
			document.getElementById("job").innerHTML = job,
            document.getElementById("grade").innerHTML =  grade;
            document.getElementById("player").innerHTML =  event.data.pName.toUpperCase();
			document.getElementById("day").innerHTML =  event.data.day;
			document.getElementById("month").innerHTML =  month;
			document.getElementById("year").innerHTML =  event.data.year;
			document.getElementById("hr").innerHTML =  event.data.hour;
			document.getElementById("min").innerHTML =  event.data.minute;
			document.getElementById("sec").innerHTML =  event.data.second;
        }
		else if (event.data.open == "update") {
			var month = monthNames[(event.data.month - 1)]
			document.getElementById("day").innerHTML =  event.data.day;
			document.getElementById("month").innerHTML =  month;
			document.getElementById("year").innerHTML =  event.data.year;
			document.getElementById("hr").innerHTML =  event.data.hour;
			document.getElementById("min").innerHTML =  event.data.minute;
			document.getElementById("sec").innerHTML =  event.data.second;
		}
        else if(event.data.open == false) 
        {
            $(".bodycam").fadeOut();
        }
    })
});