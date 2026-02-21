using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class VialToss : Ability
    {
        public VialToss()
        {
            Name = "Vial Toss";
            FlavorText = "Corrosive acid eats through armor.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
