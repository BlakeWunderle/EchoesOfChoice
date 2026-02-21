using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Riptide : Ability
    {
        public Riptide()
        {
            Name = "Riptide";
            FlavorText = "A sudden current drags at the target's legs.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
