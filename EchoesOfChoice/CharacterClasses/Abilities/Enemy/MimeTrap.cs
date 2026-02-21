using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class MimeTrap : Ability
    {
        public MimeTrap()
        {
            Name = "Mime Trap";
            FlavorText = "The enemy is trapped in an invisible box.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
