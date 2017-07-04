////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////*******************************    CONFIG ACTION RESULTS   ***************************************//////////////
   
    function Action (id_element,value){
        switch(id_element)
        { 
            case 'Codigo': $('[asp_id="id_Codigo"]').val(value); break;
            case 'Cliente': $('[asp_id="id_Cliente"]').val(value); break;
            case 'Vendedor': $('[asp_id="id_Vendedor"]').val(value); break;
            case 'Sucursal': $('[asp_id="id_Sucursal"]').val(value); break;
            case 'Rack': $('[asp_id="id_Rack"]').val(value); break;
    
        }   
        //ActionFormMain(id_element,value); //Scrips/default               
    }

    function ActionReset (id_element){
        switch(id_element)
        {          
            case 'Codigo': $('[asp_id="id_Codigo"]').val('0'); break;
            case 'Cliente': $('[asp_id="id_Cliente"]').val('0'); break;
            case 'Vendedor': $('[asp_id="id_Vendedor"]').val('0'); break;
            case 'Sucursal': $('[asp_id="id_Sucursal"]').val('0'); break;
            case 'Rack': $('[asp_id="id_Rack"]').val('0'); break;

		}
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////************************************         CODE        *****************************************//////////////

    var indexOfSelectedElement=-1;
    var dataForValidate = false;

    function SetUpAutoComplete (){    
        $.each($('input[type=text][autocomplete=on]'), function (key, val) {
            AddEvents($(this));
        });
    }

    function GenerateStruct(id_element){
       var element = $('#autocomplete'+id_element);
       var struct;
       struct = '<div style="float:left;"><div>'+element.html()+ '</div>' ; 
       struct += '<div id="searchResults'+id_element+'" class="searchResults"></div>';
       struct += '</div>';   
       struct += '<div class = "validation">';       
       struct += '<div id = "erro'+id_element+'" class ="validationText" ></div></div>';    
       element.html(struct);
    }

    function AddEvents (jqueryObjet){
       var id_element = jqueryObjet.attr("id");   
       GenerateStruct(id_element); 
       jqueryObjet = $('#'+id_element); //asignacion de nuevo elemento generado por el generateStruc (no mover)
       jqueryObjet.keyup(function(e){KeyPress(e,id_element);});
       jqueryObjet.blur(function() {HideResults(id_element);});   
       //jqueryObjet.focusout(function() {HideResults(id_element)});
       jqueryObjet.focus(function() {resetAutoComplete(jqueryObjet)});
       jqueryObjet.bind('keydown keypress',function(e) {
            if (e.keyCode == 38 || e.keyCode == 40 || e.keyCode == 13) { e.preventDefault(); }
       });     
    }
    
    function resetAutoComplete(jqueryObjet){
        indexOfSelectedElement=-1;StatusElement(jqueryObjet.attr("id"),"reset");jqueryObjet.val("");
    }

    function KeyPress(e, id_element) {
        var jqueryObjet = $('#' + id_element);
        dataForValidate = true;

        if (e.keyCode == '40') {
            // Down Key		
            SelectResult(indexOfSelectedElement + 1, id_element);
        } else if (e.keyCode == '38') {
            // Up Key
            SelectResult(indexOfSelectedElement - 1, id_element);
        } else if (e.keyCode == '13') {
            // Enter Key		
            EnterKeyPressed(id_element);
        } else {
            indexOfSelectedElement = -1;
            //var server = "http://localhost:61961/";
            //alert($('[asp_id="id_Sucursal"]').val());

            if (jqueryObjet.attr('search') == "Rack") {
                alert($('#Codigo').val());
            }

            var search = "../autocomplete.aspx?q=" + jqueryObjet.val() + "&op=" + jqueryObjet.attr('search') + "&id_element=" + id_element;
            search = replaceAll(search, "'", "");

            if (jqueryObjet.val().length > 0) {
                $.ajax({
                    url: search,
                    cache: false,
                    success: function (data) {
                        jqueryObjet = $('#searchResults' + id_element);
                        jqueryObjet.stop(true, true).html(data).css({ 'display': 'block' });
                    }
                });
            }
        }
    }

    function SelectResult(indexOfElementToSelect, id_element) {
        
        dataForValidate=true;
        indexOfElementToSelect=(indexOfElementToSelect>=0)? indexOfElementToSelect:0;
	    var jqueryObjet = $('#'+id_element+indexOfElementToSelect);
	    if (indexOfSelectedElement >= 0){	   
	        $('#'+id_element+indexOfSelectedElement).removeClass('resultsHighlight');		
	    }	
	    if (jqueryObjet.length){		
	        jqueryObjet.addClass('resultsHighlight');		
            $('#'+id_element).val(jqueryObjet.html());
	        indexOfSelectedElement = indexOfElementToSelect;       
	    }			    
    }

    function ClickOnResult(indexOfElementToSelect,id_element){        
        var jqueryObjet = $('#'+id_element+indexOfElementToSelect);             
        $('#'+id_element).val(jqueryObjet.html());       
        HideResults(id_element);          
     }

    function EnterKeyPressed(id_element){  
        if (indexOfSelectedElement >= 0) {
            $('#'+id_element+indexOfSelectedElement).click();
        }
        else
            $('#'+id_element).blur();        
    }

    function HideResults(id_element) {                
	    if (dataForValidate){
	        dataForValidate = false;
	        $('#searchResults'+id_element).animate({opacity:'0.1'},0, function() {		
                $(this).css({'display': 'none'});
                $(this).css({'opacity': '1.0'});            
	        });	        
	        VerificationData(id_element);	        
	        indexOfSelectedElement = -1;
	        	        
	        $('#searchResults'+id_element).html('');
	    }	
    }

    function VerificationData (id_element){
       var jqueryObjet;    
       if (indexOfSelectedElement == -1)
        {
            var search_string = $('#'+id_element).val().toUpperCase();
            jqueryObjet=$('#'+id_element+'0');
            if (jqueryObjet.length){               
                var data = jqueryObjet.html().toUpperCase();           
                if (search_string == data){                
                    Action (id_element,$('#'+id_element + "0").attr("id_element"));
                    StatusElement(id_element,'true');
                }
                if (id_element == 'Cliente') {
                    var value = data.split(" -");
                    if (search_string == value[0]) {
                        Action(id_element, $('#' + id_element + "0").attr("id_element"));
                        StatusElement(id_element, 'true');
                    }
                }
            }                              
            else {
                if ($.trim(search_string) == '')StatusElement(id_element,"reset");
                else{ StatusElement(id_element,"false");
                Action (id_element,-1);}
            }
        }else
        {
            Action (id_element,$('#'+id_element + indexOfSelectedElement).attr("id_element"));
            StatusElement(id_element,'true');
        }    
    }   

    function StatusElement (id_element,value){
        switch(value)
        {
            case 'reset':           
                
                $('#erro'+id_element).html("");
                ActionReset (id_element);
            break;
            case 'true':           
                
                $('#erro'+id_element).html("");
            break;
            case 'false':           
                
                $('#erro'+id_element).html("Error");
            break;
        }
    }
    
     function replaceAll(txt, replace, with_this) {
        return txt.replace(new RegExp(replace, 'g'),with_this);
    }