using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Consecrate : Ability
    {
        public Consecrate()
        {
            Name = "Consecrate";
            FlavorText = "Holy energy consecrates the ground, bolstering an ally's defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 6;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 4;
        }
    }
}
