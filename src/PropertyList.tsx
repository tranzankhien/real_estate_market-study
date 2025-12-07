import { Container, Flex, Heading, Text, Card, Grid, Badge } from "@radix-ui/themes";

interface PropertyListProps {
  onSelectProperty: (id: string) => void;
}

export function PropertyList({ onSelectProperty }: PropertyListProps) {
  // TODO: Sẽ query danh sách properties từ blockchain
  // Hiện tại là mock data để demo UI
  
  const mockProperties = [
    {
      id: "0x123...",
      title: "Nhà 3 tầng view biển",
      location: "Đà Nẵng",
      price: 5000000,
      area: 120,
      type: "Nhà",
      imageUrl: "https://via.placeholder.com/300x200",
      isAvailable: true,
    },
    {
      id: "0x456...",
      title: "Căn hộ cao cấp trung tâm",
      location: "Hà Nội",
      price: 3000000,
      area: 80,
      type: "Căn hộ",
      imageUrl: "https://via.placeholder.com/300x200",
      isAvailable: true,
    },
  ];

  const getPropertyTypeLabel = (type: string) => {
    switch (type) {
      case "Nhà": return "🏠";
      case "Đất": return "🌳";
      case "Căn hộ": return "🏢";
      default: return "";
    }
  };

  return (
    <Container>
      <Heading size="5" mb="4">Danh sách Bất động sản</Heading>
      
      <Grid columns={{ initial: "1", sm: "2", md: "3" }} gap="4">
        {mockProperties.map((property) => (
          <Card
            key={property.id}
            style={{ cursor: "pointer" }}
            onClick={() => onSelectProperty(property.id)}
          >
            <img
              src={property.imageUrl}
              alt={property.title}
              style={{
                width: "100%",
                height: "200px",
                objectFit: "cover",
                borderRadius: "8px 8px 0 0",
              }}
            />
            
            <Flex direction="column" gap="2" p="3">
              <Flex justify="between" align="center">
                <Text size="2" weight="bold">
                  {getPropertyTypeLabel(property.type)} {property.type}
                </Text>
                {property.isAvailable && (
                  <Badge color="green">Đang bán</Badge>
                )}
              </Flex>

              <Heading size="3">{property.title}</Heading>
              
              <Text size="2" color="gray">
                📍 {property.location}
              </Text>

              <Flex justify="between" align="center">
                <Text size="2" weight="bold" color="blue">
                  💰 {property.price.toLocaleString()} IOTA
                </Text>
                <Text size="2" color="gray">
                  📐 {property.area}m²
                </Text>
              </Flex>
            </Flex>
          </Card>
        ))}
      </Grid>

      {mockProperties.length === 0 && (
        <Flex justify="center" align="center" style={{ minHeight: "200px" }}>
          <Text color="gray">Chưa có bất động sản nào</Text>
        </Flex>
      )}
    </Container>
  );
}
