angular.module('weather-module', []);

angular.module('weather-module').service('weatherService', ['$http', function($http) {
	this.getWeather = function(location) {
		var p = {params : location};
		p.params.APPID = '53f9d8e4213222cf517d86dc406d67fc';  
		p.params.units = 'metric'; 
		
		return $http.get("http://api.openweathermap.org/data/2.5/weather", p);
	}
}]);

angular.module('weather-module').controller('WeatherController', ['$scope', 'weatherService', '$rootScope',
		function($scope, weatherService, $rootScope){
			
			var self = this;

			self.statuses = { 
				LOADING: 0,
				READY: 1
			};

			self.model = {
				location : {
					lat : '',
					lon : ''
				},
				weather : {},
				status : self.statuses.READY,
				errorMessage : '',
				error : false
			};
			
			self.setError = function(message) {
				self.model.error = true;
				self.model.errorMessage = message; 
				self.model.status = self.statuses.READY;
				$rootScope.$digest();
			}
			
			self.clearError = function() {
				self.model.error = false;
				self.model.errorMessage = '';
			}
			
			self.showPosition = function(position) {
				self.model.location = {
					lat : position.coords.latitude, 
					lon : position.coords.longitude
				};
				self.refresh();
			};				
			
			self.showError = function(error) {
				switch(error.code) {
					case error.PERMISSION_DENIED:
						self.setError("Location information withheld.");
						break;
					case error.POSITION_UNAVAILABLE:
						self.setError("Location information is unavailable.");
						break;
					case error.TIMEOUT:
						self.setError("The request to get user location timed out.");
						break;
					case error.UNKNOWN_ERROR:
						self.setError("An unknown error occurred.");
						break;
				}
			};
			
			self.getLocation = function () {
				self.clearError();
				if (navigator.geolocation) {
					navigator.geolocation.getCurrentPosition(self.showPosition, self.showError);
				} else {
					self.setError("Geolocation is not supported by this browser.");
				}
			};

			self.isReady = function() {
				if (self.model.status == self.statuses.READY) {
					return true;
				}
				return false;
			};
			
			self.refresh = function() {
				
				self.model.status = self.statuses.LOADING;
				
				weatherService.getWeather(self.model.location)
				.then(function(response) {
					self.model.weather = response;
				}).catch(function(e){
					self.setError("Weather data could not be found.");
				}).finally(function(){
					self.model.status = self.statuses.READY;
				});
			};

			self.getCity = function() {
				return self.model.city;
			};
			
			self.getLon = function(){
				var lon = 0;
				try {
					lon = self.model.weather.data.coord.lon;
				} catch (e) {
					
				}
				return lon;
			};
			
			self.getLat = function(){
				var lat = 0;
				try {
					lat = self.model.weather.data.coord.lat;
				} catch (e) {
					
				}
				return lat;
			};
			
			self.getWeather = function() {
				return {
					city : self.model.city,
					weather : self.model.weather
				};
			};

			self.getLocation();
			
			return self;
		}
]);
