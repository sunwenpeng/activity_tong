function BidInfo(name,phone,price,order){
    this.name = name
    this.phone = phone
    this.price = price
    this.order = order
}

BidInfo.prototype.pro = function(){
    this.price = Number((this.price).trim());
}