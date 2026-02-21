using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Ovation : Ability
    {
        public Ovation()
        {
            Name = "Ovation";
            FlavorText = "The roar of the crowd fuels an ally's fighting spirit. Increases attacks.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
