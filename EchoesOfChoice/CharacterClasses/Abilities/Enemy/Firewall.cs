using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Firewall : Ability
    {
        public Firewall()
        {
            var random = new System.Random();
            Name = "Firewall";
            FlavorText = "Activates defensive protocols -- results may vary. Increases defense.";
            ModifiedStat = StatEnum.Defense;
            Modifier = random.Next(-5, 10);
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = random.Next(3, 7);
        }
    }
}
